// lib/models/calculator_settings.dart

enum AppThemeMode { light, dark, system }  // ← Đổi ThemeMode → AppThemeMode

class CalculatorSettings {
  final AppThemeMode themeMode;      // ← Đổi ở đây
  final int decimalPrecision;
  final bool hapticFeedback;
  final bool soundEffects;
  final int historySize;

  const CalculatorSettings({
    this.themeMode        = AppThemeMode.dark,  // ← Đổi ở đây
    this.decimalPrecision = 6,
    this.hapticFeedback   = true,
    this.soundEffects     = false,
    this.historySize      = 50,
  });

  CalculatorSettings copyWith({
    AppThemeMode? themeMode,           // ← Đổi ở đây
    int? decimalPrecision,
    bool? hapticFeedback,
    bool? soundEffects,
    int? historySize,
  }) {
    return CalculatorSettings(
      themeMode:        themeMode        ?? this.themeMode,
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      hapticFeedback:   hapticFeedback   ?? this.hapticFeedback,
      soundEffects:     soundEffects     ?? this.soundEffects,
      historySize:      historySize      ?? this.historySize,
    );
  }
}