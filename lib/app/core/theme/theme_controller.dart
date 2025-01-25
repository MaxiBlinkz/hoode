import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final isDarkMode = false.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = storage.read('isDarkMode') ?? false;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    storage.write('isDarkMode', value);
  }
}
