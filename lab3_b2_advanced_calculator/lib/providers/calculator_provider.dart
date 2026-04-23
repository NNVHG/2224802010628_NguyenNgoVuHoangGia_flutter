// lib/providers/calculator_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';
import '../models/calculator_mode.dart';
import '../utils/expression_parser.dart';
import 'package:flutter/services.dart';

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
    _loadHistory();
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
    _angleMode = (_angleMode == AngleMode.degrees)
        ? AngleMode.radians
        : AngleMode.degrees;
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
    _expression = _memory.toString();
    notifyListeners();
  }

  void memoryClear() {
    _memory = 0;
    notifyListeners();
  }

  void onButtonPressed(String value) {
    if (_isSoundOn) {
      SystemSound.play(SystemSoundType.click);
    }
    if (value == 'C') {
      clear();
    } else if (value == 'CE') {
      deleteLastCharacter();
    } else if (value == '=') {
      calculate();
    } else if (value == '+/-') {
      toggleSign();
    } else if (value == '%') {
      addPercentage();
    } else if (value == '( )') {
      addParentheses();
    } else if (value == 'x²') {
      _applyUnaryOp('²');
    } else if (value == '√') {
      _expression = 'sqrt($_expression)';
      notifyListeners();
    } else if (value == 'sin') {
      _expression = 'sin($_expression)';
      notifyListeners();
    } else if (value == 'cos') {
      _expression = 'cos($_expression)';
      notifyListeners();
    } else if (value == 'tan') {
      _expression = 'tan($_expression)';
      notifyListeners();
    } else if (value == 'ln') {
      _expression = 'log($_expression)';
      notifyListeners();
    } else if (value == 'log') {
      _expression = 'log($_expression)/log(10)';
      notifyListeners();
    } else if (value == 'x^y') {
      _expression += '^';
      notifyListeners();
    } else if (value == 'π') {
      _expression += 'π';
      notifyListeners();
    } else {
      addToExpression(value);
    }
  }

  void _applyUnaryOp(String op) {
    _expression += op;
    notifyListeners();
  }

  void addToExpression(String value) {
    _expression += value;
    notifyListeners();
  }

  void deleteLastCharacter() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      notifyListeners();
    }
  }

  void clear() {
    _expression = '';
    _result = '0';
    notifyListeners();
  }

  void toggleSign() {
    if (_expression.isNotEmpty) {
      if (_expression.startsWith('-')) {
        _expression = _expression.substring(1);
      } else {
        _expression = '-$_expression';
      }
      notifyListeners();
    }
  }

  void addPercentage() {
    if (_expression.isNotEmpty) {
      _expression += '%';
      notifyListeners();
    }
  }

  void addParentheses() {
    int openCount = _expression.split('(').length - 1;
    int closeCount = _expression.split(')').length - 1;
    if (openCount > closeCount) {
      _expression += ')';
    } else {
      _expression += '(';
    }
    notifyListeners();
  }

  void calculate() {
    try {
      bool isDeg = _angleMode == AngleMode.degrees;
      String finalExpression = CalcParser.preProcess(_expression, isDeg);

      finalExpression = finalExpression.replaceAllMapped(
        RegExp(r'sqrt\(([^)]+)\)'),
            (m) => '(${m[1]})^0.5',
      );

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

  Future<void> _saveToHistory(String exp, String res) async {
    final prefs = await SharedPreferences.getInstance();
    final newRecord = CalculationHistory(
      expression: exp,
      result: res,
      timestamp: DateTime.now(),
    );
    _history.insert(0, newRecord);
    if (_history.length > 50) {
      _history.removeLast();
    }
    final historyJson =
    _history.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('calc_history', historyJson);
    notifyListeners();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();

    // Tải cài đặt âm thanh 1 lần duy nhất khi mở app
    _isSoundOn = prefs.getBool('sound_effects') ?? true;

    List<String>? historyString = prefs.getStringList('calc_history');
    if (historyString != null) {
      _history = historyString.map((item) => CalculationHistory.fromJson(jsonDecode(item))).toList();
      notifyListeners();
    }
  }

  Future<void> clearAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _history.clear();
    await prefs.remove('calc_history');
    notifyListeners();
  }
}