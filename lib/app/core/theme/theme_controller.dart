import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final isDarkMode = false.obs;
  final isNeoBrutalismEnabled = false.obs;
  final currentScheme = FlexScheme.material.obs;
  final storage = GetStorage();
  final accentColor = MaterialColor(0xFFFFEB3B, {
  50: Color(0xFFFFFDE7),
  100: Color(0xFFFFF9C4),
  200: Color(0xFFFFF59D),
  300: Color(0xFFFFF176),
  400: Color(0xFFFFEE58),
  500: Color(0xFFFFEB3B),
  600: Color(0xFFFDD835),
  700: Color(0xFFFBC02D),
  800: Color(0xFFF9A825),
  900: Color(0xFFF57F17),
}).obs;

  @override
  void onInit() {
    super.onInit();
    ever(isDarkMode, (_) => _applyTheme());
    ever(currentScheme, (_) => _applyTheme());
    ever(isNeoBrutalismEnabled, (_) => _applyTheme());
    
    isNeoBrutalismEnabled.value = storage.read('isNeoBrutalismEnabled') ?? false;
    isDarkMode.value = storage.read('isDarkMode') ?? false;
    currentScheme.value = _loadScheme();
  }

  FlexScheme _loadScheme() {
    String? schemeName = storage.read('colorScheme');
    return schemeName != null
        ? FlexScheme.values.firstWhere((scheme) => scheme.name == schemeName,
            orElse: () => FlexScheme.material)
        : FlexScheme.material;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    storage.write('isDarkMode', value);
    _applyTheme();
  }

  void updateAccentColor(MaterialColor color) {
    accentColor.value = color;
    _applyTheme();
  }

  void toggleNeoBrutalism(bool value) {
    isNeoBrutalismEnabled.value = value;
    storage.write('isNeoBrutalismEnabled', value);
    _applyTheme();
  }

  void changeScheme(FlexScheme scheme) {
    currentScheme.value = scheme;
    storage.write('colorScheme', scheme.name);
    _applyTheme();
  }

  void _applyTheme() {
  final baseTheme = isDarkMode.value 
      ? FlexThemeData.dark(scheme: currentScheme.value)
      : FlexThemeData.light(scheme: currentScheme.value);

  if (isNeoBrutalismEnabled.value) {
    Get.changeTheme(baseTheme.copyWith(
      scaffoldBackgroundColor: isDarkMode.value ? Colors.grey[900] : Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 8,
        backgroundColor: isDarkMode.value ? Colors.grey[900] : Colors.white,
        shadowColor: Colors.black,
        shape: Border(bottom: BorderSide(color: Colors.black, width: 3)),
      ),
      cardTheme: CardTheme(
        elevation: 8,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: Colors.black, width: 3),
        ),
        color: isDarkMode.value ? Colors.grey[800] : Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: Colors.black,
          backgroundColor: accentColor.value,
          foregroundColor: Colors.black,
          padding: EdgeInsets.all(16),
          side: BorderSide(color: Colors.black, width: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        elevation: 8,
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: Colors.black, width: 3),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDarkMode.value ? Colors.grey[800] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.black, width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.black, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: accentColor.value, width: 3),
        ),
      ),
    ));
  } else {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    Get.changeTheme(baseTheme);
  }
}


}
