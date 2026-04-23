import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../models/calculator_mode.dart';
import 'calculator_button.dart';

class ButtonGrid extends StatelessWidget {
  final List<String> buttons;
  final int crossAxisCount;

  const ButtonGrid({Key? key, required this.buttons, required this.crossAxisCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int cols = crossAxisCount;
        int rows = (buttons.length / cols).ceil();
        double spacing = 8.0;
        double btnSize = math.min((constraints.maxWidth - 24 - (cols - 1) * spacing) / cols, (constraints.maxHeight - (rows - 1) * spacing) / rows);

        return Center(
          child: SizedBox(
            width: btnSize * cols + (cols - 1) * spacing,
            height: btnSize * rows + (rows - 1) * spacing,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final btnText = buttons[index];
                if (btnText.isEmpty) return const SizedBox.shrink();
                return CalculatorButton(
                  text: btnText,
                  onPressed: () => context.read<CalculatorProvider>().onButtonPressed(btnText),
                  onLongPress: btnText == 'C' ? () => context.read<CalculatorProvider>().clearAllHistory() : null,
                );
              },
            ),
          ),
        );
      },
    );
  }
}