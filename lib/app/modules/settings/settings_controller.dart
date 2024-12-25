import 'package:get/get.dart';

class SettingsController extends GetxController {
  final isDarkMode = false.obs;
  final isNotificationsEnabled = true.obs;
  final selectedLanguage = 'English'.obs;
  final selectedCurrency = 'USD'.obs;

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    // Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
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
