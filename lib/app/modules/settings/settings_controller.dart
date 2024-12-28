import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final isDarkMode = Get.isDarkMode.obs;
  final isNotificationsEnabled = true.obs;
  final selectedLanguage = 'English'.obs;
  final selectedCurrency = 'USD'.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    final savedTheme = storage.read('theme_mode');
    if (savedTheme != null) {
      isDarkMode.value = savedTheme == 'dark';
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    storage.write('theme_mode', value ? 'dark' : 'light');
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

