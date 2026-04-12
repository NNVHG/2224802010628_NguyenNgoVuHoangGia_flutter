import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}
// tính toán
class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  String equation = '';

  void onButtonPressed(String text) {
    setState(() {
      if (display == 'Error') {
        display = '0';
      }

      if (text == 'C') {
        display = '0';
        equation = '';
      }
      else if (text == '( )') {
        int openBrackets = display.split('(').length - 1;
        int closeBrackets = display.split(')').length - 1;

        if (display == '0') {
          display = '(';
        } else if (openBrackets > closeBrackets) {
          if (RegExp(r'[0-9)]$').hasMatch(display)) {
            display += ')';
          } else {
            display += '(';
          }
        } else {
          if (RegExp(r'[0-9)]$').hasMatch(display)) {
            display += '*(';
          } else {
            display += '(';
          }
        }
      }
      else if (text == '+/-') {
        if (display != '0') {
          if (display.startsWith('-')) {
            display = display.substring(1);
          } else {
            display = '-$display';
          }
        }
      }
      else if (text == '=') {
        try {
          equation = display;

          String finalExpr = display.replaceAll('%', '/100');

          Parser p = Parser();
          Expression exp = p.parse(finalExpr);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          display = eval.toString();
          if (display.endsWith('.0')) {
            display = display.substring(0, display.length - 2);
          }
        } catch (e) {
          display = 'Error';
        }
      }
      else {
        if (display == '0') {
          if (text == '.' || text == '+' || text == '-' || text == '*' || text == '/') {
            display += text;
          } else {
            display = text;
          }
        } else {
          display += text;
        }
      }
    });
  }
//khung trên
  Widget buildButton(String text, Color bgColor) {
    return Container(
      width: 94.5,
      height: 94.5,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () => onButtonPressed(text),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 33),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
//khung dưới
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 440,
                height: 411.5,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1C),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        equation,
                        style: const TextStyle(color: Colors.white54, fontSize: 24)
                    ),
                    const SizedBox(height: 16),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                          display,
                          style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 440,
                height: 544.5,
                color: const Color(0xFF1C1C1C),
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    buildButton('C', const Color(0xFF963E3E)),
                    buildButton('( )', const Color(0xFF272727)),
                    buildButton('%', const Color(0xFF272727)),
                    buildButton('/', const Color(0xFF394734)),

                    buildButton('7', const Color(0xFF272727)),
                    buildButton('8', const Color(0xFF272727)),
                    buildButton('9', const Color(0xFF272727)),
                    buildButton('*', const Color(0xFF394734)),

                    buildButton('4', const Color(0xFF272727)),
                    buildButton('5', const Color(0xFF272727)),
                    buildButton('6', const Color(0xFF272727)),
                    buildButton('-', const Color(0xFF394734)),

                    buildButton('1', const Color(0xFF272727)),
                    buildButton('2', const Color(0xFF272727)),
                    buildButton('3', const Color(0xFF272727)),
                    buildButton('+', const Color(0xFF394734)),

                    buildButton('+/-', const Color(0xFF272727)),
                    buildButton('0', const Color(0xFF272727)),
                    buildButton('.', const Color(0xFF272727)),
                    buildButton('=', const Color(0xFF076544)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}