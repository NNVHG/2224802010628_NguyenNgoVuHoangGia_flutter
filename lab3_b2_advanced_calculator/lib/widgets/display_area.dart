import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../screens/history_screen.dart';

class DisplayArea extends StatefulWidget {
  const DisplayArea({Key? key}) : super(key: key);

  @override
  State<DisplayArea> createState() => _DisplayAreaState();
}

class _DisplayAreaState extends State<DisplayArea> {
  double _expressionFontSize = 48.0;
  double _baseFontSize = 48.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, provider, child) {
        return Expanded(
          flex: 3,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: (details) => _baseFontSize = _expressionFontSize,
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
                provider.deleteLastCharacter();
              } else if (velocity.dy < -300) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
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
                      style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: _expressionFontSize),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.result,
                    style: TextStyle(fontFamily: 'Inter', color: Colors.white.withOpacity(0.5), fontSize: 32),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}