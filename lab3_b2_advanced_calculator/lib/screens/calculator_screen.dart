// lib/screens/calculator_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../models/calculator_mode.dart';
import '../widgets/calculator_button.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  double _expressionFontSize = 48.0;
  double _baseFontSize = 48.0;
  final List<String> basicButtons = [
    'C', 'CE', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '+/-', '0', '.', '='
  ];

  final List<String> sciPortraitButtons = [
    'Deg', 'sin', 'cos', 'tan', 'ln', 'log',
    'x²', '√', 'x^y', '(', ')', '÷',
    'MC', '7', '8', '9', 'C', '×',
    'MR', '4', '5', '6', 'CE', '-',
    'M+', '1', '2', '3', '%', '+',
    'M-', '+/-', '0', '.', 'π', '='
  ];

  final List<String> progButtons = [
    'AND', 'OR', 'XOR', 'NOT', '<<', '>>',
    'A', 'B', '7', '8', '9', 'AC',
    'C', 'D', '4', '5', '6', '÷',
    'E', 'F', '1', '2', '3', '×',
    '(', ')', 'BIN', 'OCT', 'DEC', '-',
    'HEX', '+/-', '0', '.', '=', '+'
  ];

  final List<String> sciLandscapeButtons = [
    'Deg', 'sin', 'cos', 'tan',    'C', 'CE', '%', '÷',
    'x²', '√', 'x^y', 'ln',        '7', '8', '9', '×',
    'MC', 'MR', 'M+', 'M-',        '4', '5', '6', '-',
    'log', '(', ')', 'π',          '1', '2', '3', '+',
    '2nd', 'e', '', '',            '+/-', '0', '.', '='
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer<CalculatorProvider>(
          builder: (context, provider, child) {
            bool isBasic = provider.mode == CalculatorMode.basic;
            bool isSci = provider.mode == CalculatorMode.scientific;
            bool isProg = provider.mode == CalculatorMode.programmer;

            List<String> currentButtons;
            int crossAxisCount;
            double maxWidth;
            double aspectRatio; // Khai báo biến tỷ lệ

            if (isBasic) {
              currentButtons = basicButtons;
              crossAxisCount = 4;
              maxWidth = 440;
              aspectRatio = 1.0; // KHÓA TỶ LỆ 1.0 ĐỂ LÀM NÚT TRÒN
            } else if (isProg) {
              currentButtons = progButtons;
              crossAxisCount = 6;
              maxWidth = 440;
              aspectRatio = 1.0; // KHÓA TỶ LỆ 1.0
            } else {
              if (isLandscape || screenWidth > 650) {
                currentButtons = sciLandscapeButtons;
                crossAxisCount = 8;
                maxWidth = 850;
                aspectRatio = 1.5; // Màn ngang (Web/Tablet) thì để chữ nhật sẽ đẹp hơn
              } else {
                currentButtons = sciPortraitButtons;
                crossAxisCount = 6;
                maxWidth = 440;
                aspectRatio = 1.0; // KHÓA TỶ LỆ 1.0
              }
            }

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    // --- Thanh điều hướng trên cùng ---
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Nút lịch sử (History button)
                          IconButton(
                            icon: const Icon(Icons.history,
                                color: Color(0xFF4ECDC4)),
                            tooltip: 'Lịch sử',
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HistoryScreen()),
                            ),
                          ),
                          // Hiển thị chế độ góc DEG/RAD
                          if (isSci)
                            GestureDetector(
                              onTap: () => provider.toggleAngleMode(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFF4ECDC4)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  provider.angleMode == AngleMode.degrees
                                      ? 'DEG'
                                      : 'RAD',
                                  style: const TextStyle(
                                    color: Color(0xFF4ECDC4),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          else
                            const SizedBox(),

                          // Nút Settings + chuyển chế độ
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.settings,
                                    color: Color(0xFF4ECDC4)),
                                tooltip: 'Cài đặt',
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SettingsScreen()),
                                ),
                              ),
                              TextButton(
                                onPressed: () => provider.toggleMode(),
                                child: Text(
                                  isBasic ? 'BASIC' : (isSci ? 'SCIENTIFIC' : 'PROGRAMMER'),
                                  style: const TextStyle(
                                    color: Color(0xFF4ECDC4),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                // --- Vùng hiển thị (Display Area) ---
                Expanded(
                  flex: 2,
                  // SỬ DỤNG GESTURE DETECTOR ĐỂ BẮT CÁC CỬ CHỈ
                  // SỬ DỤNG GESTURE DETECTOR GỘP (CHỈ DÙNG SCALE)
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,

                    onScaleStart: (details) {
                      _baseFontSize = _expressionFontSize;
                    },

                    onScaleUpdate: (details) {
                      // Nếu có 2 ngón tay chạm vào (pointerCount == 2) -> Xử lý Pinch to zoom
                      if (details.pointerCount == 2) {
                        setState(() {
                          _expressionFontSize = (_baseFontSize * details.scale).clamp(24.0, 72.0);
                        });
                      }
                    },

                    onScaleEnd: (details) {
                      // Lấy vận tốc vuốt (velocity) khi người dùng nhấc ngón tay lên
                      final velocity = details.velocity.pixelsPerSecond;

                      // 1. Nếu vuốt ngang mạnh (trái hoặc phải) -> Xóa ký tự
                      if (velocity.dx.abs() > velocity.dy.abs() && velocity.dx.abs() > 300) {
                        provider.deleteLastCharacter();
                      }
                      // 2. Nếu vuốt lên mạnh (âm theo trục Y) -> Mở Lịch sử
                      else if (velocity.dy < -300) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HistoryScreen()),
                        );
                      }
                    },

                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Text(
                              provider.expression.isEmpty ? '0' : provider.expression,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: _expressionFontSize, // Size động
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.result,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                    const Divider(
                        color: Colors.blueGrey, height: 1, thickness: 1),

                    // --- Bàn phím nút bấm (Button Grid) ---
                    // --- Bàn phím nút bấm (Button Grid) ---
                    Expanded(
                      flex: isSci || isProg ? 6 : 5,
                      child: Align(
                        alignment: Alignment.bottomCenter, // Đẩy toàn bộ phím xuống đáy
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation.drive(Tween(begin: 0.95, end: 1.0)),
                                  child: child,
                                ),
                              );
                            },
                            child: GridView.builder(
                              key: ValueKey<CalculatorMode>(provider.mode), // Bắt buộc phải có cho Animation
                              shrinkWrap: true, // Ôm sát nội dung để có thể căn đáy
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: currentButtons.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: aspectRatio, // Nhận giá trị 1.0 đã set ở trên
                              ),
                              itemBuilder: (context, index) {
                                final btnText = currentButtons[index];
                                if (btnText.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return CalculatorButton(
                                  text: btnText,
                                  onPressed: () {
                                    if (btnText == 'Deg' || btnText == 'Rad') {
                                      provider.toggleAngleMode();
                                    } else if (btnText == 'M+') {
                                      provider.memoryAdd();
                                    } else if (btnText == 'M-') {
                                      provider.memorySubtract();
                                    } else if (btnText == 'MR') {
                                      provider.memoryRecall();
                                    } else if (btnText == 'MC') {
                                      provider.memoryClear();
                                    } else if (btnText == 'AC') {
                                      provider.clear();
                                    } else {
                                      provider.onButtonPressed(btnText);
                                    }
                                  },
                                  onLongPress: btnText == 'C' ? () {
                                    provider.clearAllHistory();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Đã xóa toàn bộ lịch sử!', style: TextStyle(fontFamily: 'Inter')),
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Color(0xFF963E3E),
                                      ),
                                    );
                                  } : null,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}