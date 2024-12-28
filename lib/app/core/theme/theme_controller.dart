
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  
  final themeMode = ThemeMode.system.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
  }

  void loadThemeMode() {
    final savedMode = storage.read('theme_mode');
    if (savedMode != null) {
      themeMode.value = ThemeMode.values[savedMode];
    }
  }

  void toggleTheme() {
    themeMode.value = themeMode.value == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    storage.write('theme_mode', themeMode.value.index);
    Get.changeThemeMode(themeMode.value);
  }
}
