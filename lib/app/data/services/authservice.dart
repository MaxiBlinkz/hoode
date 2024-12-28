import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/services/db_helper.dart';

class AuthService extends GetxService {
  final storage = GetStorage();
  // final pb = PocketBase(POCKETBASE_URL);
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  final isAuthenticated = false.obs;

  Future<void> checkLoginStatus() async {
    final isLoggedIn = storage.read('isLoggedIn') ?? false;
    final token = storage.read('authToken');
    final userData = storage.read('userData');

    if (isLoggedIn && token != null && userData != null) {
      pb.authStore.save(token, RecordModel.fromJson(userData));
      if (pb.authStore.isValid) {
        isAuthenticated(true);
      }
    }
  }

  void requireAuth(Function callback) {
    if (isAuthenticated.value) {
      callback();
    } else {
      Get.toNamed('/login');
    }
  }

  bool get isLoggedIn => isAuthenticated.value;

  void logout() {
    pb.authStore.clear();
    storage.write('isLoggedIn', false);
    storage.remove('authToken');
    storage.remove('userData');
    isAuthenticated(false);
    Get.offAllNamed('/login');
  }
}
