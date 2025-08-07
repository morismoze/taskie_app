import 'package:flutter/material.dart';

abstract final class AppColors {
  static const black1 = Color(0xFF101010);
  static const purple1 = Color(0xFF5F34E2);
  static const purple1Light = Color(0xFFEEE9FF);
  static const orange1 = Color(0xFFFF9142);
  static const orange1Light = Color(0xFFFEE7D4);
  static const blue1 = Color(0xFF0287FF);
  static const blue1Light = Color(0xFFE3F2FF);
  static Color green1 = Colors.green[800]!;
  static Color green1Light = Colors.green.shade50;
  static const white1 = Color(0xFFFFFFFF);
  static const grey1 = Color.fromARGB(255, 225, 225, 225);
  static const grey2 = Color(0xFF4D4D4D);
  static const grey3 = Color(0xFFA4A4A4);
  static const whiteTransparent = Color(0x4DFFFFFF);
  static const blackTransparent = Color(0x4D000000);
  static const red1 = Color(0xFFE74C3C);
  static const red1Light = Color(0xFFF8D6D2);
  static Color golden = Colors.amber[600]!;
  static Color fieldFillColor = grey2.withValues(alpha: 0.075);
  static Color fieldUnfocusedLabelColor = grey2.withValues(alpha: 0.5);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.purple1,
    onPrimary: AppColors.white1,
    secondary: AppColors.black1,
    onSecondary: AppColors.white1,
    surface: AppColors.white1,
    onSurface: AppColors.black1,
    error: AppColors.red1,
    onError: AppColors.white1,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.white1,
    onPrimary: AppColors.purple1,
    secondary: AppColors.white1,
    onSecondary: AppColors.black1,
    surface: AppColors.black1,
    onSurface: AppColors.white1,
    error: AppColors.red1,
    onError: AppColors.white1,
  );
}
