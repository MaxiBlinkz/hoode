
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  
  final themeMode = ThemeMode.system.obs;
  final isDarkMode = false.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
  }

  void loadThemeMode() {
    final savedMode = storage.read('theme_mode');
    if (savedMode != null) {
      isDarkMode.value = savedMode == 1;
      themeMode.value = isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
      Get.changeThemeMode(themeMode.value);
    }
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    themeMode.value = value ? ThemeMode.dark : ThemeMode.light;
    storage.write('theme_mode', value ? 1 : 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.changeThemeMode(themeMode.value);
    });
  }
}
