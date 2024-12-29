import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'db_helper.dart';

class AuthService extends GetxService {
  final storage = GetStorage();
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  final isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      final token = storage.read('authToken');
      final userData = storage.read('userData');

      if (token != null && userData != null) {
        pb.authStore.save(token, RecordModel.fromJson(userData));
        await pb.collection('users').authRefresh();
        
        // Update storage with fresh token
        storage.write('authToken', pb.authStore.token);
        storage.write('userData', pb.authStore.record?.toJson());
        isAuthenticated(pb.authStore.isValid);
      }
    } catch (e) {
      logout();
    }
  }

  Future<void> refreshSession() async {
    await pb.collection('users').authRefresh();
    storage.write('authToken', pb.authStore.token);
    storage.write('userData', pb.authStore.record);
  }

  void requireAuth(Function callback) {
    if (isAuthenticated.value) {
      callback();
    } else {
      Get.toNamed('/login');
    }
  }

  void saveAuthState(String token, RecordModel userData) {
    pb.authStore.save(token, userData);
    storage.write('authToken', token);
    storage.write('userData', userData.toJson());
    isAuthenticated(true);
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
