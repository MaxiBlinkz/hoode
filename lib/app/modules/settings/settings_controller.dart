import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/theme/theme_controller.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class SettingsController extends GetxController {
  final isDarkMode = Get.isDarkMode.obs;
  final isNotificationsEnabled = true.obs;
  final selectedLanguage = 'English'.obs;
  final selectedCurrency = 'USD'.obs;
  final storage = GetStorage();
  final themeController = Get.find<ThemeController>();
  final currentScheme = FlexScheme.material.obs;
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
    isDarkMode.value = themeController.isDarkMode.value;
    ever(themeController.isDarkMode, (_) => isDarkMode.value = themeController.isDarkMode.value);
  }


  void toggleTheme(bool value) {
    themeController.toggleTheme(value);
  }


  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
    // Implement notification toggle logic
  }

  void setLanguage(String language) {
    selectedLanguage.value = language;
    // Implement language change logic
  }

  void setCurrency(String currency) {
    selectedCurrency.value = currency;
    // Implement currency change logic
  }

  void logout() {
    // Implement logout logic
    Get.offAllNamed('/login');
  }
}
