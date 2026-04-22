// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculator_settings.dart';

class ThemeProvider extends ChangeNotifier {
  CalculatorSettings _settings = const CalculatorSettings();

  CalculatorSettings get settings => _settings;

  // Trả về ThemeMode của Flutter (không phải AppThemeMode của mình)
  bool get isDark => _settings.themeMode == AppThemeMode.dark;

  ThemeProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('theme_mode') ?? 1;
    final precision  = prefs.getInt('decimal_precision') ?? 6;
    final histSize   = prefs.getInt('history_size') ?? 50;
    final haptic     = prefs.getBool('haptic_feedback') ?? true;

    _settings = CalculatorSettings(
      themeMode:        AppThemeMode.values[themeIndex],  // ← AppThemeMode
      decimalPrecision: precision,
      historySize:      histSize,
      hapticFeedback:   haptic,
    );
    notifyListeners();
  }

  Future<void> setTheme(AppThemeMode mode) async {         // ← AppThemeMode
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', AppThemeMode.values.indexOf(mode));
    _settings = _settings.copyWith(themeMode: mode);
    notifyListeners();
  }

  Future<void> setDecimalPrecision(int precision) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('decimal_precision', precision);
    _settings = _settings.copyWith(decimalPrecision: precision);
    notifyListeners();
  }

  Future<void> setHistorySize(int size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('history_size', size);
    _settings = _settings.copyWith(historySize: size);
    notifyListeners();
  }

  Future<void> setHaptic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haptic_feedback', value);
    _settings = _settings.copyWith(hapticFeedback: value);
    notifyListeners();
  }
}