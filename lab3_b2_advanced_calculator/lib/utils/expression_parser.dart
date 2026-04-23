import 'dart:math' as math;

class CalcParser {

  static String preProcess(String expression, bool isDegrees) {
    String result = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('%', '/100')
        .replaceAll('π', math.pi.toString())
        .replaceAll('e', math.e.toString());

    result = result.replaceAllMapped(
      RegExp(r'(-?\d+\.?\d*)²'),
          (m) => '(${m[1]})*(${m[1]})',
    );

    if (isDegrees) {
      result = result.replaceAllMapped(
        RegExp(r'sin\(([^)]+)\)'),
            (m) => 'sin(${m[1]}*${math.pi}/180)',
      );
      result = result.replaceAllMapped(
        RegExp(r'cos\(([^)]+)\)'),
            (m) => 'cos(${m[1]}*${math.pi}/180)',
      );
      result = result.replaceAllMapped(
        RegExp(r'tan\(([^)]+)\)'),
            (m) => 'tan(${m[1]}*${math.pi}/180)',
      );
    }

    return result;
  }

  static String formatResult(double value, int precision) {
    if (value.isInfinite) return 'Infinity';
    if (value.isNaN)      return 'Error';

    String result = value.toStringAsFixed(precision);
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'0+$'), '');
      result = result.replaceAll(RegExp(r'\.$'), '');
    }
    return result;
  }
}