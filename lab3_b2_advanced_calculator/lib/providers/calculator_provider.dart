import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../models/calculation_history.dart';
import '../models/calculator_mode.dart';
import '../utils/expression_parser.dart';

class CalculatorProvider extends ChangeNotifier {
  bool _isSoundOn = true;
  String _expression = '';
  String _result = '0';
  double _memory = 0;
  CalculatorMode _mode = CalculatorMode.basic;
  AngleMode _angleMode = AngleMode.degrees;
  List<CalculationHistory> _history = [];

  List<CalculationHistory> get history => _history;
  String get expression => _expression;
  String get result => _result;
  CalculatorMode get mode => _mode;
  AngleMode get angleMode => _angleMode;
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
    } else {
      _mode = CalculatorMode.basic;
    }
    notifyListeners();
  }

  void toggleAngleMode() {
    _angleMode = (_angleMode == AngleMode.degrees) ? AngleMode.radians : AngleMode.degrees;
    notifyListeners();
  }

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
      case 'C':
        clear();
        break;
      case 'AC':
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
        _expression += 'log(10,'; // Dạng log cơ số 10
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
        _expression += value;
        notifyListeners();
    }
  }
  void addToExpression(String value) {
    _expression = value;
    _result = '0';
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
      bool isDeg = _angleMode == AngleMode.degrees;
      String finalExpression = CalcParser.preProcess(_expression, isDeg);

      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      _result = CalcParser.formatResult(eval, 10);
      _saveToHistory(_expression, _result);
      _expression = _result;
    } catch (e) {
      _result = 'Error';
    }
    notifyListeners();
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