import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';

class AuthService extends GetxService {
  final storage = GetStorage();
  final pb = PocketBase(POCKETBASE_URL);

  Future<void> checkLoginStatus() async {
    final isLoggedIn = storage.read('isLoggedIn') ?? false;
    final token = storage.read('authToken');
    final userData = storage.read('userData');

    if (isLoggedIn && token != null && userData != null) {
      // Restore auth state
      pb.authStore.save(token, RecordModel.fromJson(userData));
      // Verify if token is still valid
      if (pb.authStore.isValid) {
        Get.offAll(() => const NavBarPage());
      }
    }
  }
}
