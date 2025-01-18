import 'package:flutter/material.dart';

class ThemeClass {
  // Dark theme colors
  static const darkBackground = Color(0xFF131315);
  static const darkCards = Color(0xFF828A9D);
  static const darkPrimary = Color(0xFF3FADEC);
  static const darkText = Color(0xFFFFFFFF);

  // Light theme colors
  static const lightBackground = Color(0xFFF5F5F5);
  static const lightCards = Color(0xFFFFFFFF);
  static const lightPrimary = Color(0xFF3FADEC);
  static const lightText = Color(0xFF131315);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: ColorScheme.dark(
      surface: darkBackground,
      primary: darkPrimary,
      surfaceContainerHighest: darkCards, // Updated from surfaceVariant
      onSurface: darkText,
      onSurfaceVariant: darkText,
      onPrimary: darkText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkText,
    ),
    cardTheme: const CardTheme(
      color: darkCards,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: darkBackground,
      indicatorColor: darkPrimary,
    ),
    textTheme: const TextTheme().apply(
      bodyColor: darkText,
      displayColor: darkText,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: ColorScheme.light(
      surface: lightBackground,
      primary: lightPrimary,
      surfaceContainerHighest: lightCards,
      onSurface: lightText,
      onSurfaceVariant: lightText,
      onPrimary: lightBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightText,
    ),
    cardTheme: const CardTheme(
      color: lightCards,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: lightBackground,
      indicatorColor: lightPrimary,
    ),
    textTheme: const TextTheme().apply(
      bodyColor: lightText,
      displayColor: lightText,
    ),
  );
}
