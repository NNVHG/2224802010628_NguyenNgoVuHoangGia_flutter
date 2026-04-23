// lib/screens/calculator_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../models/calculator_mode.dart';
import '../widgets/calculator_button.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'dart:math' as math;

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

  final List<String> sciLandscapeButtons = [
    'Deg', 'sin', 'cos', 'tan',    'C', 'CE', '%', '÷',
    'x²', '√', 'x^y', 'ln',        '7', '8', '9', '×',
    'MC', 'MR', 'M+', 'M-',        '4', '5', '6', '-',
    'log', '(', ')', 'π',          '1', '2', '3', '+',
    '2nd', 'e', '', '',            '+/-', '0', '.', '='
  ];

  final List<String> progButtons = [
    'AND', 'OR', 'XOR', 'NOT', '<<', '>>',
    'A', 'B', '7', '8', '9', 'AC',
    'C', 'D', '4', '5', '6', '÷',
    'E', 'F', '1', '2', '3', '×',
    '(', ')', 'BIN', 'OCT', 'DEC', '-',
    'HEX', '+/-', '0', '.', '=', '+'
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Tắt SafeArea viền đáy ở Scaffold để giao quyền đẩy bàn phím xuống đáy
      body: SafeArea(
        bottom: false,
        child: Consumer<CalculatorProvider>(
          builder: (context, provider, child) {
            bool isBasic = provider.mode == CalculatorMode.basic;
            bool isSci = provider.mode == CalculatorMode.scientific;
            bool isProg = provider.mode == CalculatorMode.programmer;

            List<String> currentButtons;
            int crossAxisCount;
            double maxWidth;
            double aspectRatio;

            if (isBasic) {
              currentButtons = basicButtons;
              crossAxisCount = 4;
              maxWidth = 440;
              aspectRatio = 1.0; // Nút tròn
            } else if (isProg) {
              currentButtons = progButtons;
              crossAxisCount = 6;
              maxWidth = 440;
              aspectRatio = 1.0; // Nút tròn
            } else {
              if (isLandscape || screenWidth > 650) {
                currentButtons = sciLandscapeButtons;
                crossAxisCount = 8;
                maxWidth = 850;
                aspectRatio = 1.5; // Web/Tablet quay ngang thì dùng nút chữ nhật
              } else {
                currentButtons = sciPortraitButtons;
                crossAxisCount = 6;
                maxWidth = 440;
                aspectRatio = 1.0; // Nút tròn
              }
            }

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    // --- Thanh điều hướng trên cùng ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.history, color: Color(0xFF4ECDC4)),
                            tooltip: 'Lịch sử',
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const HistoryScreen()),
                            ),
                          ),
                          if (isSci)
                            GestureDetector(
                              onTap: () => provider.toggleAngleMode(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFF4ECDC4)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  provider.angleMode == AngleMode.degrees ? 'DEG' : 'RAD',
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

                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.settings, color: Color(0xFF4ECDC4)),
                                tooltip: 'Cài đặt',
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
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
// --- Vùng hiển thị (Display Area) ---
                    Expanded(
                      flex: 3, // Dành 30% màn hình cho vùng số
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onScaleStart: (details) {
                          _baseFontSize = _expressionFontSize;
                        },
                        onScaleUpdate: (details) {
                          if (details.pointerCount == 2) {
                            setState(() {
                              _expressionFontSize = (_baseFontSize * details.scale).clamp(24.0, 72.0);
                            });
                          }
                        },
                        onScaleEnd: (details) {
                          final velocity = details.velocity.pixelsPerSecond;
                          if (velocity.dx.abs() > velocity.dy.abs() && velocity.dx.abs() > 300) {
                            context.read<CalculatorProvider>().deleteLastCharacter();
                          } else if (velocity.dy < -300) {
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
                                    fontSize: _expressionFontSize,
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

                    const Divider(color: Colors.blueGrey, height: 1, thickness: 1),

                    // --- Bàn phím nút bấm (Button Grid) ---
                    Expanded(
                      flex: 7, // Dành 70% màn hình cho bàn phím
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            int cols = crossAxisCount;
                            int rows = (currentButtons.length / cols).ceil();
                            double spacing = 8.0;

                            // Trừ đi 24px padding 2 bên (12px mỗi bên)
                            double availableWidth = constraints.maxWidth - 24;
                            double availableHeight = constraints.maxHeight;

                            // Tính kích thước tối đa của 1 nút để vừa chiều ngang HOẶC chiều dọc
                            double maxBtnWidth = (availableWidth - (cols - 1) * spacing) / cols;
                            double maxBtnHeight = (availableHeight - (rows - 1) * spacing) / rows;

                            // CỐT LÕI: Chọn kích thước nhỏ hơn để đảm bảo nút luôn lọt thỏm vào màn hình và giữ đúng hình tròn 1:1
                            double btnSize = math.min(maxBtnWidth, maxBtnHeight);

                            // Kích thước thật của toàn bộ lưới sau khi ép nút tròn
                            double gridWidth = btnSize * cols + (cols - 1) * spacing;
                            double gridHeight = btnSize * rows + (rows - 1) * spacing;

                            return Center( // Căn giữa toàn bộ bàn phím để cân đối 2 bên
                              child: SizedBox(
                                width: gridWidth,
                                height: gridHeight,
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
                                    key: ValueKey<CalculatorMode>(provider.mode),
                                    physics: const NeverScrollableScrollPhysics(), // Tắt cuộn hoàn toàn
                                    itemCount: currentButtons.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: cols,
                                      crossAxisSpacing: spacing,
                                      mainAxisSpacing: spacing,
                                      childAspectRatio: 1.0, // GIỮ NGUYÊN NÚT TRÒN THEO YÊU CẦU
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
                            );
                          },
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