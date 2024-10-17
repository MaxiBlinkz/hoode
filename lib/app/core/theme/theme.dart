import 'package:flutter/material.dart';

class ThemeClass {
  Color lightPrimaryColor = Color(0xFF00000);
  Color darkPrimaryColor = Color(0xFF00000);

  Color lightBackgroundColor = Color(0xFF00000);
  Color darkBackgroundColor = Color(0xFF00000);

  Color lightSecondaryColor = Color(0xFF00000);
  Color darkSecondaryColor = Color(0xFF00000);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light().copyWith(),

    //-.-.-.-.-.-.-.-.- Button Themes -.-.-.-.-.-.-.-.- 
    elevatedButtonTheme: const ElevatedButtonThemeData(),
    textTheme: TextTheme()
  );
}

ThemeClass _themeClass = ThemeClass();
