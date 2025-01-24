import 'package:flutter/material.dart';

// Primary Colors
const Color primaryBlue = Color(0xFF3A86FF);
const Color accentOrange = Color(0xFFFFB703);
const Color lightGray = Color(0xFFF5F5F5);
const Color darkGray = Color(0xFF333333);
const Color lightGreen = Color(0xFF00FF00);

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: lightGray,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightGray,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: darkGray,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: darkGray),
    ),
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue, brightness: Brightness.light),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkGray),
      bodyMedium: TextStyle(color: darkGray),
      bodySmall: TextStyle(color: darkGray),
      titleLarge: TextStyle(color: darkGray, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: darkGray, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(color: darkGray, fontWeight: FontWeight.bold),

    ),
    iconTheme: const IconThemeData(color: primaryBlue),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primaryBlue
    ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: primaryBlue)),
    checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryBlue;
          }
          return Colors.grey;
        }),
        checkColor: WidgetStateProperty.all(Colors.white))
);

//Dark theme
ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor:
        const Color(0xFF1A1A1A), // Dark background for dark theme
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
        iconTheme: IconThemeData(color: Colors.white)
    ),
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue, brightness: Brightness.dark),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    iconTheme: const IconThemeData(color: primaryBlue),
    cardTheme: CardTheme(
        color: const Color(0xFF2B2B2B),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryBlue)
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: primaryBlue)),
    checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryBlue;
          }
          return Colors.grey;
        }),
        checkColor: WidgetStateProperty.all(Colors.white))
);

// Custom Text Styles
TextStyle h1TextStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: darkGray);


TextStyle h2TextStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: darkGray
);

TextStyle bodyTextStyle = const TextStyle(
    fontSize: 16,
    color: darkGray
);

TextStyle priceTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: darkGray
);

TextStyle captionTextStyle = const TextStyle(
  fontSize: 12,
  color: Colors.grey,
);


// Custom Button Styles

ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryBlue,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8)
  ),
  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
);

ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: primaryBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8)
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
    side: const BorderSide(color: primaryBlue)
);
