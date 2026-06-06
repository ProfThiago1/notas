import 'package:flutter/material.dart';
import 'paleta.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.lightGray,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.darkGray),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 117, 117, 117), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.grafite,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.darkGray),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 117, 117, 117), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
