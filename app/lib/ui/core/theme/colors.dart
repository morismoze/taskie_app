import 'package:flutter/material.dart';

abstract final class AppColors {
  static const black1 = Color(0xFF101010);
  static const purple1 = Color(0xFF5F34E2);
  static const purple1Light = Color(0xFFEEE9FF);
  static const white1 = Color(0xFFFFFFFF);
  static const grey1 = Color(0xFFF2F2F2);
  static const grey2 = Color(0xFF4D4D4D);
  static const grey3 = Color(0xFFA4A4A4);
  static const whiteTransparent = Color(0x4DFFFFFF);
  static const blackTransparent = Color(0x4D000000);
  static const red1 = Color(0xFFE74C3C);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.purple1,
    onPrimary: AppColors.white1,
    secondary: AppColors.black1,
    onSecondary: AppColors.white1,
    surface: Colors.white,
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
    onSurface: Colors.white,
    error: AppColors.red1,
    onError: AppColors.white1,
  );
}
