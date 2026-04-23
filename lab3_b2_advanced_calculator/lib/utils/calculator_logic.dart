// lib/utils/calculator_logic.dart

enum NumberBase { bin, oct, dec, hex }

class ProgrammerLogic {
  static int parse(String input, NumberBase base) {
    switch (base) {
      case NumberBase.bin:
        return int.parse(input, radix: 2);
      case NumberBase.oct:
        return int.parse(input, radix: 8);
      case NumberBase.dec:
        return int.parse(input, radix: 10);
      case NumberBase.hex:
        return int.parse(input, radix: 16);
    }
  }

  static String format(int value, NumberBase base) {
    switch (base) {
      case NumberBase.bin:
        return value.toRadixString(2);
      case NumberBase.oct:
        return value.toRadixString(8);
      case NumberBase.dec:
        return value.toString();
      case NumberBase.hex:
        return value.toRadixString(16).toUpperCase();
    }
  }

  static String convert(String input, NumberBase from, NumberBase to) {
    try {
      final intValue = parse(input, from);
      return format(intValue, to);
    } catch (_) {
      return 'Error';
    }
  }

  // Phép toán bitwise (Bitwise operations)
  static int and(int a, int b)        => a & b;
  static int or(int a, int b)         => a | b;
  static int xor(int a, int b)        => a ^ b;
  static int not(int a)               => ~a;
  static int leftShift(int a, int b)  => a << b;
  static int rightShift(int a, int b) => a >> b;
}