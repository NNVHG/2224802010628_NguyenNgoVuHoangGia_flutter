import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../models/calculator_mode.dart';
import '../widgets/calculator_button.dart';
import 'history_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // 1. Basic Mode (4x5) - Giữ nguyên không thay đổi
  final List<String> basicButtons = [
    'C', '( )', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '+/-', '0', '.', '='
  ];

  // 2. Scientific Mode - Dọc (Mobile Portrait) (6x6)
  final List<String> sciPortraitButtons = [
    'Deg', 'sin', 'cos', 'tan', 'ln', 'log',
    'x²', '√', 'x^y', '(', ')', '÷',
    'MC', '7', '8', '9', 'C', '×',
    'MR', '4', '5', '6', 'CE', '-',
    'M+', '1', '2', '3', '%', '+',
    'M-', '+/-', '0', '.', 'π', '='
  ];

  // 3. Scientific Mode - Ngang (Landscape/Web) (8x5)
  // Tách hàm khoa học bên trái (4 cột), phím số bên phải (4 cột)
  final List<String> sciLandscapeButtons = [
    'Deg', 'sin', 'cos', 'tan',    'C', 'CE', '%', '÷',
    'x²', '√', 'x^y', 'ln',        '7', '8', '9', '×',
    'MC', 'MR', 'M+', 'M-',        '4', '5', '6', '-',
    'log', '(', ')', 'π',          '1', '2', '3', '+',
    '2nd', 'e', '', '',            '+/-', '0', '.', '='
    // Lưu ý: Có 2 ô trống ('') để lấp đầy không gian lưới cho đẹp mắt
  ];

  @override
  Widget build(BuildContext context) {
    // Nhận diện kích thước và chiều hướng màn hình
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Center(
        child: Consumer<CalculatorProvider>(
          builder: (context, provider, child) {
            bool isSci = provider.mode == CalculatorMode.scientific;

            // XÁC ĐỊNH RESPONSIVE BỐ CỤC
            List<String> currentButtons;
            int crossAxisCount;
            double maxWidth;
            double aspectRatio; // Tỷ lệ khung hình của nút

            if (!isSci) {
              // Chế độ Basic
              currentButtons = basicButtons;
              crossAxisCount = 4;
              maxWidth = 440;
              aspectRatio = 1.0; // Nút hình vuông tròn đều
            } else {
              // Chế độ Khoa học
              if (isLandscape || screenWidth > 650) {
                // Màn hình ngang (Tablet / Web)
                currentButtons = sciLandscapeButtons;
                crossAxisCount = 8; // Trải dài 8 cột
                maxWidth = 850;
                aspectRatio = 1.5; // Kéo dãn nút ra hình chữ nhật một chút để tránh tràn màn hình dọc
              } else {
                // Màn hình dọc (Mobile)
                currentButtons = sciPortraitButtons;
                crossAxisCount = 6;
                maxWidth = 440;
                aspectRatio = 1.0;
              }
            }

            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                children: [
                  // Thanh chọn chế độ (Basic / Scientific)
                  Padding(
                    padding: const EdgeInsets.only(top: 40, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => provider.toggleMode(),
                          child: Text(
                            isSci ? 'BASIC' : 'SCIENTIFIC',
                            style: const TextStyle(
                              color: Color(0xFF4ECDC4),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Vùng hiển thị kết quả (Display Area)
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: GestureDetector(
                        onVerticalDragEnd: (details) {
                          if (details.primaryVelocity! < 0) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
                          }
                        },
                        onHorizontalDragEnd: (details) {
                          context.read<CalculatorProvider>().deleteLastCharacter();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true,
                              child: Text(
                                provider.expression.isEmpty ? '0' : provider.expression,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  fontSize: 48,
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

                  // Bàn phím nút bấm
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: currentButtons.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: aspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          String btnText = currentButtons[index];

                          // Ẩn các nút trống ('') để lấp đầy không gian lưới
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
                              } else {
                                provider.onButtonPressed(btnText);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}