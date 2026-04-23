// lib/utils/constants.dart
import 'package:flutter/material.dart';

class AppColors {
  // Light Theme (Chủ đề sáng)
  static const Color lightPrimary    = Color(0xFF1E1E1E);
  static const Color lightSecondary  = Color(0xFF424242);
  static const Color lightAccent     = Color(0xFFFF6B6B);

  // Dark Theme (Chủ đề tối)
  static const Color darkBackground  = Color(0xFF121212);
  static const Color darkSurface     = Color(0xFF2C2C2C);
  static const Color darkAccent      = Color(0xFF4ECDC4);

  // Calculator specific (Màu riêng cho máy tính)
  static const Color btnNumber       = Color(0xFF272727);
  static const Color btnOperator     = Color(0xFF394734);
  static const Color btnClear        = Color(0xFF963E3E);
  static const Color btnEquals       = Color(0xFF076544);
  static const Color btnMemory       = Color(0xFF2C3E50);
  static const Color btnScientific   = Color(0xFF1A237E);
}

class AppSizes {
  static const double buttonRadius   = 16.0;
  static const double displayRadius  = 24.0;
  static const double screenPadding  = 24.0;
  static const double buttonSpacing  = 12.0;
  static const int    animationMs    = 200;
  static const int    modeAnimMs     = 300;
}