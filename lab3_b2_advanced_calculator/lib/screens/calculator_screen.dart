import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../models/calculator_mode.dart';
import '../widgets/display_area.dart';
import '../widgets/button_grid.dart';
import '../widgets/mode_selector.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  // Khai báo các bàn phím cố định ngay tại tầng UI
  static const List<String> basicButtons = [
    'C', 'CE', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '+/-', '0', '.', '='
  ];

  static const List<String> sciPortraitButtons = [
    'Deg', 'sin', 'cos', 'tan', 'ln', 'log',
    'x²', '√', 'x^y', '(', ')', '÷',
    'MC', '7', '8', '9', 'C', '×',
    'MR', '4', '5', '6', 'CE', '-',
    'M+', '1', '2', '3', '%', '+',
    'M-', '+/-', '0', '.', 'π', '='
  ];

  static const List<String> sciLandscapeButtons = [
    'Deg', 'sin', 'cos', 'tan',    'C', 'CE', '%', '÷',
    'x²', '√', 'x^y', 'ln',        '7', '8', '9', '×',
    'MC', 'MR', 'M+', 'M-',        '4', '5', '6', '-',
    'log', '(', ')', 'π',          '1', '2', '3', '+',
    '2nd', 'e', '', '',            '+/-', '0', '.', '='
  ];

  static const List<String> progButtons = [
    'AND', 'OR', 'XOR', 'NOT', '<<', '>>',
    'A', 'B', '7', '8', '9', 'AC',
    'C', 'D', '4', '5', '6', '÷',
    'E', 'F', '1', '2', '3', '×',
    '(', ')', 'BIN', 'OCT', 'DEC', '-',
    'HEX', '+/-', '0', '.', '=', '+'
  ];

  @override
  Widget build(BuildContext context) {
    // Nhận diện kích thước để xử lý Responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Consumer<CalculatorProvider>(
          builder: (context, provider, child) {

            // XỬ LÝ LOGIC GIAO DIỆN TẠI ĐÂY
            List<String> currentButtons;
            int crossAxisCount;
            double maxWidth;

            if (provider.mode == CalculatorMode.basic) {
              currentButtons = basicButtons;
              crossAxisCount = 4;
              maxWidth = 440;
            } else if (provider.mode == CalculatorMode.programmer) {
              currentButtons = progButtons;
              crossAxisCount = 6;
              maxWidth = 440;
            } else {
              if (isLandscape || screenWidth > 650) {
                currentButtons = sciLandscapeButtons;
                crossAxisCount = 8;
                maxWidth = 850;
              } else {
                currentButtons = sciPortraitButtons;
                crossAxisCount = 6;
                maxWidth = 440;
              }
            }

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    const ModeSelector(),  // Gọi Component Thanh điều hướng
                    const DisplayArea(),   // Gọi Component Màn hình số
                    const Divider(color: Colors.blueGrey, height: 1, thickness: 1),
                    Expanded(
                      flex: 7,
                      child: ButtonGrid(   // Gọi Component Lưới nút bấm
                        buttons: currentButtons,
                        crossAxisCount: crossAxisCount,
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