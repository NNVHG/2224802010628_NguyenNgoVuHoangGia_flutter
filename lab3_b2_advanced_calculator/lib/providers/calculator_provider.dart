import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';
import '../models/calculator_mode.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _result = '0';
  double _memory = 0;
  CalculatorMode _mode = CalculatorMode.basic;
  AngleMode _angleMode = AngleMode.degrees;
  List<CalculationHistory> _history = [];

  // Getters - Đã thêm đầy đủ history để HistoryScreen nhận được dữ liệu
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
    _mode = (_mode == CalculatorMode.basic) ? CalculatorMode.scientific : CalculatorMode.basic;
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
    _expression = _memory.toString();
    notifyListeners();
  }

  void memoryClear() {
    _memory = 0;
    notifyListeners();
  }

  void onButtonPressed(String value) {
    if (value == 'C') {
      clear();
    } else if (value == '=') {
      calculate();
    } else if (value == '+/-') {
      toggleSign();
    } else if (value == '%') {
      addPercentage();
    } else if (value == '( )') {
      addParentheses();
    } else {
      addToExpression(value);
    }
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
        _expression = '-' + _expression;
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

  // CHỈ CÓ ĐÚNG MỘT HÀM CALCULATE NÀY TRONG FILE
  void calculate() {
    try {
      String finalExpression = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/100')
          .replaceAll('π', math.pi.toString())
          .replaceAll('e', math.e.toString());

      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Định dạng số thập phân đẹp hơn
      _result = eval.toStringAsFixed(10);
      if (_result.contains('.')) {
        _result = _result.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
      }

      _saveToHistory(_expression, _result);
      _expression = _result;
    } catch (e) {
      _result = 'Error';
    }
    notifyListeners();
  }

  // --- Lịch sử tính toán ---
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
    List<String> historyJson = _history.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('calc_history', historyJson);
    notifyListeners();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
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