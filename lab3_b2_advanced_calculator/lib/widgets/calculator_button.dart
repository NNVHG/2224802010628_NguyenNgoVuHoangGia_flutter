import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CalculatorButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  // Hàm xác định màu nền (background color) dựa vào ký tự của nút
  Color get _backgroundColor {
    if (text == 'C') return const Color(0xFF963E3E); // Màu đỏ
    if (text == '=') return const Color(0xFF076544); // Màu xanh lá sáng
    if (['÷', '×', '-', '+', '%', '( )'].contains(text)) {
      return const Color(0xFF394734); // Màu xanh rêu tối
    }
    return const Color(0xFF272727); // Màu xám đậm cho số và dấu .
  }

  // Hàm xác định màu chữ (text color)
  Color get _textColor {
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _backgroundColor,
        foregroundColor: _textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Bo tròn hoàn toàn theo CSS
        ),
        padding: EdgeInsets.zero,
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 38, // Điều chỉnh size chữ cho phù hợp với khung hình
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}