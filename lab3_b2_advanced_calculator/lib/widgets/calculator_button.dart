import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  const CalculatorButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  // Biến quản lý tỷ lệ thu phóng của nút
  double _scale = 1.0;

  Color get _backgroundColor {
    if (widget.text == 'C' || widget.text == 'AC' || widget.text == 'CE') return const Color(0xFF963E3E);
    if (widget.text == '=') return const Color(0xFF076544);
    if (['÷', '×', '-', '+', '%', '( )', '(', ')'].contains(widget.text)) {
      return const Color(0xFF394734);
    }
    return const Color(0xFF272727);
  }

// Mở file lib/widgets/calculator_button.dart và cập nhật hàm build:

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _scale = 0.9),
      onPointerUp: (_) => setState(() => _scale = 1.0),
      onPointerCancel: (_) => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          onLongPress: widget.onLongPress,
          style: ElevatedButton.styleFrom(
            backgroundColor: _backgroundColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              // GIỮ LẠI NÚT TRÒN HOÀN HẢO THEO ĐÚNG THIẾT KẾ CSS
              borderRadius: BorderRadius.circular(100),
            ),
            // Tăng padding để chữ thu nhỏ lại, không bị đâm ra viền cong của nút tròn
            padding: const EdgeInsets.all(8),
            elevation: 0,
            splashFactory: NoSplash.splashFactory,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 32, // Chữ sẽ tự động co lại nhờ FittedBox nếu quá dài
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}