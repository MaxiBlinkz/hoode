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

  @override
  void onInit() {
    super.onInit();
    ever(themeController.isDarkMode, (_) => isDarkMode.value = themeController.isDarkMode.value);
    ever(themeController.currentScheme, (_) => currentScheme.value = themeController.currentScheme.value);
  }

  void toggleTheme(bool value) {
    themeController.toggleTheme(value);
  }

  void changeColorScheme(FlexScheme scheme) {
    themeController.changeScheme(scheme);
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
