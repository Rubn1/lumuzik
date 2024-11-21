import 'package:flutter/material.dart';
import 'package:lumuzik/core/configs/theme/app_colors.dart';

class AppTheme {
  // Styles communs
  static final TextStyle headingStyle = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontFamily: 'Satoshi',
  );

  static final TextStyle inputLabelStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey[700],
    fontFamily: 'Satoshi',
  );

  static final TextStyle buttonTextStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: 'Satoshi',
  );

  static final TextStyle subheadingStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
    fontFamily: 'Satoshi',
  );

  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    labelStyle: inputLabelStyle,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
  );

  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    fontFamily: 'Satoshi',
    inputDecorationTheme: inputDecorationTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: buttonTextStyle,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,
    fontFamily: 'Satoshi',
    inputDecorationTheme: inputDecorationTheme.copyWith(
      fillColor: AppColors.darkGey,
      labelStyle: inputLabelStyle.copyWith(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: buttonTextStyle,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}