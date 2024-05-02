import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static Color main = const Color(0xff48148c);
  static Color text = const Color(0xff48148c);
  static Color text1 = const Color(0xFF000000);
  static Color textLight = const Color(0xFF666666);
  static Color white = const Color(0xffffffff);
}

class Sizes {
  static const double defaultSpace = 24.0;
  static const double spaceBetweenItems = 16.0;
  static const double spaceBetweenSections = 32.0;
}

class Themes {
  static ThemeData defaultTheme = ThemeData(
      fontFamily: GoogleFonts.oxygen().fontFamily,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.white,
          iconTheme: IconThemeData(color: AppColors.text),
          titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.text)),
      colorScheme: ColorScheme.light(
          primary: AppColors.main, secondary: AppColors.main));
}

class TextStyles {
  static TextStyle heading1 = TextStyle(
      fontWeight: FontWeight.bold, color: AppColors.text, fontSize: 48);

  static TextStyle heading2 = TextStyle(
      fontWeight: FontWeight.bold, color: AppColors.text, fontSize: 32);

  static TextStyle heading3 = TextStyle(
      fontWeight: FontWeight.bold, color: AppColors.text, fontSize: 24);

  static TextStyle heading4 = TextStyle(
      fontWeight: FontWeight.bold, color: AppColors.text1, fontSize: 16);

  static TextStyle body3 = TextStyle(
      fontWeight: FontWeight.bold, color: AppColors.textLight, fontSize: 12);

  static TextStyle body1 = TextStyle(
      fontWeight: FontWeight.normal, color: AppColors.text, fontSize: 18);

  static TextStyle body2 = TextStyle(
      fontWeight: FontWeight.normal, color: AppColors.text, fontSize: 16);
}
