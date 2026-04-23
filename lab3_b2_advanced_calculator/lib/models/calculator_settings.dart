enum AppThemeMode { light, dark, system }

class CalculatorSettings {
  final AppThemeMode themeMode;
  final int decimalPrecision;
  final bool hapticFeedback;
  final bool soundEffects;
  final int historySize;

  const CalculatorSettings({
    this.themeMode        = AppThemeMode.dark,
    this.decimalPrecision = 6,
    this.hapticFeedback   = true,
    this.soundEffects     = false,
    this.historySize      = 50,
  });

  CalculatorSettings copyWith({
    AppThemeMode? themeMode,
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