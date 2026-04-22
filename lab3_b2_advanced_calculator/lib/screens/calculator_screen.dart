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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(                          // ← Bọc SafeArea tránh tràn
        child: Consumer<CalculatorProvider>(
          builder: (context, provider, child) {
            bool isSci = provider.mode == CalculatorMode.scientific;

            List<String> currentButtons;
            int crossAxisCount;
            double maxWidth;
            double aspectRatio;

            if (!isSci) {
              currentButtons = basicButtons;
              crossAxisCount = 4;
              maxWidth = 440;
              aspectRatio = 1.0;
            } else {
              if (isLandscape || screenWidth > 650) {
                currentButtons = sciPortraitButtons;
                crossAxisCount = 6;
                maxWidth = 600;
                aspectRatio = 1.2;
              } else {
                currentButtons = sciPortraitButtons;
                crossAxisCount = 6;
                maxWidth = 440;
                aspectRatio = 0.9;
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
                          // Nút lịch sử (History button) ← THÊM MỚI
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
                                  isSci ? 'BASIC' : 'SCIENTIFIC',
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
                      child: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! < 0) {
                            provider.deleteLastCharacter();
                          }
                        },
                        child: Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Biểu thức đang nhập (current expression)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                reverse: true,
                                child: Text(
                                  provider.expression.isEmpty
                                      ? '0'
                                      : provider.expression,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Kết quả trước (previous result)
                              Text(
                                provider.result,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              // Indicator bộ nhớ (Memory indicator)
                              if (provider.hasMemory)
                                const Text(
                                  'M',
                                  style: TextStyle(
                                    color: Color(0xFF4ECDC4),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
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
                    Expanded(
                      flex: isSci ? 6 : 5,   // ← Tăng flex khi scientific
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: currentButtons.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: aspectRatio,
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
              ),
            );
          },
        ),
      ),
    );
  }
}