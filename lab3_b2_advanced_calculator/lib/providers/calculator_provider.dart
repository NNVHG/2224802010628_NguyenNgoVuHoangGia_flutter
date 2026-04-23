import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../models/calculation_history.dart';
import '../models/calculator_mode.dart';
import '../utils/expression_parser.dart';
import '../utils/calculator_logic.dart';

class CalculatorProvider extends ChangeNotifier {
  bool _isSoundOn = true;
  String _expression = '';
  String _result = '0';
  double _memory = 0;

  CalculatorMode _mode = CalculatorMode.basic;
  AngleMode _angleMode = AngleMode.degrees;
  NumberBase _numberBase = NumberBase.dec;

  List<CalculationHistory> _history = [];

  List<CalculationHistory> get history => _history;
  String get expression => _expression;
  String get result => _result;
  CalculatorMode get mode => _mode;
  AngleMode get angleMode => _angleMode;
  NumberBase get numberBase => _numberBase;
  bool get hasMemory => _memory != 0;

  CalculatorProvider() {
    _initProvider();
  }

  Future<void> _initProvider() async {
    await _loadSettings();
    await _loadHistory();
  }

  void toggleMode() {
    if (_mode == CalculatorMode.basic) {
      _mode = CalculatorMode.scientific;
    } else if (_mode == CalculatorMode.scientific) {
      _mode = CalculatorMode.programmer;
      _numberBase = NumberBase.dec;
    } else {
      _mode = CalculatorMode.basic;
    }
    clear();
    notifyListeners();
  }

  void toggleAngleMode() {
    _angleMode = (_angleMode == AngleMode.degrees) ? AngleMode.radians : AngleMode.degrees;
    notifyListeners();
  }

  // --- Logic Bộ nhớ (Memory) ---
  void memoryAdd() {
    _memory += double.tryParse(_result) ?? 0;
    notifyListeners();
  }

  void memorySubtract() {
    _memory -= double.tryParse(_result) ?? 0;
    notifyListeners();
  }

  void memoryRecall() {
    _expression += _memory.toString();
    notifyListeners();
  }

  void memoryClear() {
    _memory = 0;
    notifyListeners();
  }

  // --- Xử lý sự kiện nút bấm ---
  void onButtonPressed(String value) {
    if (_isSoundOn) {
      SystemSound.play(SystemSoundType.click);
    }

    switch (value) {
      case 'HEX':
      case 'DEC':
      case 'OCT':
      case 'BIN':
        _setBase(value);
        break;
      case 'AND':
      case 'OR':
      case 'XOR':
      case '<<':
      case '>>':
        _expression += ' $value ';
        notifyListeners();
        break;
      case 'NOT':
        _expression = 'NOT($_expression)';
        notifyListeners();
        break;
      case 'A':
      case 'B':
      case 'D':
      case 'E':
      case 'F':
        addToExpression(value);
        break;

    // CÁC NÚT ĐIỀU KHIỂN & KHOA HỌC
      case 'C':
        if (_mode == CalculatorMode.programmer) {
          addToExpression('C');
        } else {
          clear();
        }
        break;
      case 'AC':
        clear();
        break;
      case 'CE':
        deleteLastCharacter();
        break;
      case '=':
        calculate();
        break;
      case '+/-':
        toggleSign();
        break;
      case '%':
        _expression += '%';
        notifyListeners();
        break;
      case '( )':
        addParentheses();
        break;
      case 'x²':
        _expression += '^2';
        notifyListeners();
        break;
      case '√':
        _expression += 'sqrt(';
        notifyListeners();
        break;
      case 'sin':
      case 'cos':
      case 'tan':
      case 'ln':
        _expression += '$value(';
        notifyListeners();
        break;
      case 'log':
        _expression += 'log(10,';
        notifyListeners();
        break;
      case 'x^y':
        _expression += '^';
        notifyListeners();
        break;
      case 'π':
        _expression += 'π';
        notifyListeners();
      case 'e':
        _expression += 'e';
        notifyListeners();
        break;
      default:
        addToExpression(value);
    }
  }

  void addToExpression(String value) {
    _expression += value;
    notifyListeners();
  }

  void _setBase(String baseStr) {
    NumberBase newBase;
    switch (baseStr) {
      case 'HEX': newBase = NumberBase.hex; break;
      case 'OCT': newBase = NumberBase.oct; break;
      case 'BIN': newBase = NumberBase.bin; break;
      default: newBase = NumberBase.dec; break;
    }

    if (_expression.isNotEmpty && !_expression.contains(' ')) {
      try {
        _expression = ProgrammerLogic.convert(_expression, _numberBase, newBase);
      } catch (e) {
        _expression = ''; // Lỗi thì xóa
      }
    }
    _numberBase = newBase;
    notifyListeners();
  }

  void deleteLastCharacter() {
    if (_expression.isEmpty) return;

    final List<String> customFunctions = ['sin(', 'cos(', 'tan(', 'sqrt(', 'log(', 'ln('];
    bool deleted = false;

    for (var func in customFunctions) {
      if (_expression.endsWith(func)) {
        _expression = _expression.substring(0, _expression.length - func.length);
        deleted = true;
        break;
      }
    }

    if (!deleted) {
      _expression = _expression.substring(0, _expression.length - 1);
    }
    notifyListeners();
  }

  void clear() {
    _expression = '';
    _result = '0';
    notifyListeners();
  }

  void toggleSign() {
    if (_expression.isEmpty) return;
    if (_expression.startsWith('-')) {
      _expression = _expression.substring(1);
    } else {
      _expression = '-$_expression';
    }
    notifyListeners();
  }

  void addParentheses() {
    int openCount = _expression.split('(').length - 1;
    int closeCount = _expression.split(')').length - 1;
    if (openCount > closeCount && !_expression.endsWith('(')) {
      _expression += ')';
    } else {
      _expression += '(';
    }
    notifyListeners();
  }

  // --- Logic Tính toán ---
  void calculate() {
    if (_expression.isEmpty) return;

    try {
      if (_mode == CalculatorMode.programmer) {
        // TÍNH TOÁN DÀNH RIÊNG CHO LẬP TRÌNH VIÊN
        _result = _calculateProgrammer();
      } else {
        // TÍNH TOÁN DÀNH CHO BASIC & SCIENTIFIC
        bool isDeg = _angleMode == AngleMode.degrees;
        String finalExpression = CalcParser.preProcess(_expression, isDeg);

        Parser p = Parser();
        Expression exp = p.parse(finalExpression);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);

        _result = CalcParser.formatResult(eval, 10);
      }

      _saveToHistory(_expression, _result);
      _expression = _result;
    } catch (e) {
      _result = 'Error';
    }
    notifyListeners();
  }

  // Hàm xử lý toán tử bitwise
  String _calculateProgrammer() {
    final tokens = _expression.trim().split(' ');

    if (tokens.length == 3) {
      int a = ProgrammerLogic.parse(tokens[0], _numberBase);
      String op = tokens[1];
      int b = ProgrammerLogic.parse(tokens[2], _numberBase);

      int res = 0;
      switch (op) {
        case 'AND': res = ProgrammerLogic.and(a, b); break;
        case 'OR': res = ProgrammerLogic.or(a, b); break;
        case 'XOR': res = ProgrammerLogic.xor(a, b); break;
        case '<<': res = ProgrammerLogic.leftShift(a, b); break;
        case '>>': res = ProgrammerLogic.rightShift(a, b); break;
      }
      return ProgrammerLogic.format(res, _numberBase);
    }

    else if (_expression.startsWith('NOT(') && _expression.endsWith(')')) {
      int a = ProgrammerLogic.parse(_expression.substring(4, _expression.length - 1), _numberBase);
      return ProgrammerLogic.format(ProgrammerLogic.not(a), _numberBase);
    }

    int val = ProgrammerLogic.parse(_expression, _numberBase);
    return ProgrammerLogic.format(val, _numberBase);
  }

  // --- Lưu trữ dữ liệu (Persistence) ---
  Future<void> _saveToHistory(String exp, String res) async {
    final prefs = await SharedPreferences.getInstance();
    final newRecord = CalculationHistory(
      expression: exp,
      result: res,
      timestamp: DateTime.now(),
    );

    _history.insert(0, newRecord);
    if (_history.length > 50) _history.removeLast();

    final historyJson = _history.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('calc_history', historyJson);
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? historyString = prefs.getStringList('calc_history');
    if (historyString != null) {
      _history = historyString.map((item) => CalculationHistory.fromJson(jsonDecode(item))).toList();
      notifyListeners();
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundOn = prefs.getBool('sound_effects') ?? true;
  }

  Future<void> clearAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _history.clear();
    await prefs.remove('calc_history');
    notifyListeners();
  }
}