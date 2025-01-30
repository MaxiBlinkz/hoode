import 'package:flutter/material.dart';

// Primary Colors
const Color primaryBlue = Color(0xFF3A86FF);
const Color accentOrange = Color(0xFFFFB703);
const Color lightGray = Color(0xFFF5F5F5);
const Color darkGray = Color(0xFF333333);
const Color lightGreen = Color(0xFF00FF00);
const Color lightBlue = Color(0xFFE6F1FF);
const Color outgoingMessageColor = Color(0xFFE8F5FF);
const Color incomingMessageColor = Color(0xFFF5F5F5);
const Color messageTextColor = Color(0xFF2B2B2B);



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
    titleLarge:
        TextStyle(color: darkGray, fontWeight: FontWeight.bold, fontSize: 40.0),
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
      checkColor: WidgetStateProperty.all(Colors.white)),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: lightGray,
    indicatorColor: primaryBlue,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryBlue),
       borderRadius: BorderRadius.circular(10)
    ) ,
     errorBorder:  OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
       borderRadius: BorderRadius.circular(10)
    )
  ),
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
      checkColor: WidgetStateProperty.all(Colors.white)),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: darkGray,
    indicatorColor: primaryBlue,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
     focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryBlue),
       borderRadius: BorderRadius.circular(10)
    ),
    errorBorder:  OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
       borderRadius: BorderRadius.circular(10)
    )
  ),
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

//Dashboard Specific Text Styles
TextStyle dashboardTitleTextStyle = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: darkGray);
TextStyle dashboardSubTitleTextStyle = const TextStyle(
    fontSize: 20,
    color: Colors.grey,
    fontWeight: FontWeight.w400
);

TextStyle sectionTitleTextStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: darkGray
);

TextStyle recentActivityTextStyle = const TextStyle(
  fontSize: 16,
  color: darkGray,
);

//Message page styles
TextStyle messageText = const TextStyle(
  fontSize: 16,
  color: messageTextColor,
);

OutlineInputBorder inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(16),
  borderSide: BorderSide(color: Colors.grey.shade200),
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