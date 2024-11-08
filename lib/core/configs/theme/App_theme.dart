import 'package:flutter/material.dart';
import 'package:lumuzik/core/configs/theme/App_colors.dart';
// import 'package:lumuzik/main.dart';

class AppTheme {
  static final lightTheme  = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: const Color.fromARGB(255, 2, 2, 2),
    brightness: Brightness.light,
    fontFamily: 'Satoshi',
    elevatedButtonTheme: ElevatedButtonThemeData(    
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF8C00),
        textStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30))
        ) 
      )
    );

    static final darkTheme  = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,
    fontFamily: 'Satoshi',
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color.fromARGB(0, 255, 123, 0),
        hintStyle: TextStyle(
          color: const Color.fromARGB(255, 231, 190, 41),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.all(30),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 0.4
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 0.4
          )
        )
      ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        textStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30))
        ) 
      )
    );
}