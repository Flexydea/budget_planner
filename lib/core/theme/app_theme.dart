import 'package:flutter/material.dart';

class AppTheme {
  //Light theme

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.black26,
      surface: Colors.grey[100]!, // cards/inputs a bit grey

      tertiary: Colors.white,
      outline: Colors.grey.shade400,
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  // Dark Theme

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.white70,
      tertiary: Colors.black,
      surface: Colors
          .grey[900]!, // cards/inputs slightly lighter

      outline: Colors.grey.shade700,
    ),
    scaffoldBackgroundColor: Colors.black,
  );
}
