// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lab3_b2_advanced_calculator/utils/expression_parser.dart';

void main() {
  // --- Test ExpressionParser (Kiểm tra bộ phân tích biểu thức) ---
  group('ExpressionParser', () {

    test('Tiền xử lý phép nhân ×', () {
      final result = ExpressionParser.preProcess('3×4', false);
      expect(result.contains('*'), isTrue);
    });

    test('Tiền xử lý phép chia ÷', () {
      final result = ExpressionParser.preProcess('8÷2', false);
      expect(result.contains('/'), isTrue);
    });

    test('Tiền xử lý π thành số', () {
      final result = ExpressionParser.preProcess('π', false);
      expect(result.contains('3.14'), isTrue);
    });

    test('Định dạng số nguyên (integer)', () {
      expect(ExpressionParser.formatResult(5.0, 6), equals('5'));
    });

    test('Định dạng số thập phân (decimal)', () {
      expect(ExpressionParser.formatResult(3.14, 2), equals('3.14'));
    });

    test('Xử lý lỗi: vô cực (infinity)', () {
      expect(ExpressionParser.formatResult(double.infinity, 6), equals('Infinity'));
    });

    test('Xử lý lỗi: NaN', () {
      expect(ExpressionParser.formatResult(double.nan, 6), equals('Error'));
    });

    test('Tiền xử lý sin với độ (degrees)', () {
      final result = ExpressionParser.preProcess('sin(90)', true);
      expect(result.contains('180'), isTrue); // Đã nhân với π/180
    });

    test('Tiền xử lý sin với radian', () {
      final result = ExpressionParser.preProcess('sin(1.57)', false);
      // Không nhân với π/180 khi dùng radian
      expect(result.contains('180'), isFalse);
    });
  });
}