import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab3_b2_advanced_calculator/providers/calculator_provider.dart';
import 'package:lab3_b2_advanced_calculator/models/calculator_mode.dart';

void main() {
  // THÊM DÒNG NÀY ĐỂ FIX LỖI BINDING CỦA SYSTEM SOUND
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Kiểm thử CalculatorProvider (Logic và Toán học)', () {

    test('1. Trạng thái khởi tạo mặc định phải chính xác', () {
      final provider = CalculatorProvider();
      expect(provider.expression, '');
      expect(provider.result, '0');
      expect(provider.mode, CalculatorMode.basic);
    });

    test('2. Kiểm tra phép tính cơ bản (Cộng & Trừ)', () {
      final provider = CalculatorProvider();
      provider.onButtonPressed('5');
      provider.onButtonPressed('+');
      provider.onButtonPressed('1');
      provider.onButtonPressed('0');
      provider.onButtonPressed('=');

      expect(provider.result, '15');
    });

    test('3. Kiểm tra tính năng xóa (Nút C)', () {
      final provider = CalculatorProvider();
      provider.onButtonPressed('9');
      provider.onButtonPressed('×');
      provider.onButtonPressed('9');
      provider.clear(); // Bấm nút C

      expect(provider.expression, '');
      expect(provider.result, '0');
    });

    test('4. Kiểm tra tính năng xóa lùi (Vuốt để xóa)', () {
      final provider = CalculatorProvider();
      provider.onButtonPressed('1');
      provider.onButtonPressed('2');
      provider.onButtonPressed('3');
      provider.deleteLastCharacter();

      expect(provider.expression, '12');
    });

    test('5. Kiểm tra tính năng Bộ nhớ (Memory: M+, MR, MC)', () {
      final provider = CalculatorProvider();

      // Tính 5 + 5 = 10
      provider.onButtonPressed('5');
      provider.onButtonPressed('+');
      provider.onButtonPressed('5');
      provider.onButtonPressed('='); // Result = 10

      // Lưu 10 vào M+
      provider.memoryAdd();
      expect(provider.hasMemory, true);

      // Xóa màn hình
      provider.clear();

      // Gọi lại MR (Memory Recall)
      provider.memoryRecall();
      expect(provider.expression, '10.0'); // Bộ nhớ thường lưu dạng double

      // Xóa bộ nhớ (MC)
      provider.memoryClear();
      expect(provider.hasMemory, false);
    });
  });
}