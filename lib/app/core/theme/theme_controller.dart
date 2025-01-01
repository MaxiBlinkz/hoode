import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final isDarkMode = false.obs;
  final currentScheme = FlexScheme.material.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    ever(isDarkMode, (_) => _applyTheme());
    ever(currentScheme, (_) => _applyTheme());
    
    isDarkMode.value = storage.read('isDarkMode') ?? false;
    currentScheme.value = _loadScheme();
  }

  FlexScheme _loadScheme() {
    String? schemeName = storage.read('colorScheme');
    return schemeName != null 
        ? FlexScheme.values.firstWhere(
            (scheme) => scheme.name == schemeName,
            orElse: () => FlexScheme.material)
        : FlexScheme.material;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    storage.write('isDarkMode', value);
    _applyTheme();
  }

  void changeScheme(FlexScheme scheme) {
    currentScheme.value = scheme;
    storage.write('colorScheme', scheme.name);
    _applyTheme();
  }

  void _applyTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    Get.changeTheme(
      isDarkMode.value 
          ? FlexThemeData.dark(scheme: currentScheme.value)
          : FlexThemeData.light(scheme: currentScheme.value)
    );
  }
}
