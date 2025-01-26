import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'db_helper.dart';

class AuthService extends GetxService {
  final storage = GetStorage();
  late final PocketBase pb;
  final isAuthenticated = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    String url = await DbHelper.getPocketbaseUrl();
    pb = PocketBase(url);
    await checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
  try {
    final token = storage.read('authToken');
    final userData = storage.read('userData');

    if (token != null && userData != null) {
      pb.authStore.save(token, RecordModel.fromJson(userData));
      await pb.collection('users').authRefresh();
      storage.write('authToken', pb.authStore.token);
      storage.write('userData', pb.authStore.record?.toJson());
      isAuthenticated(pb.authStore.isValid);
    }
  } catch (e) {
    // Keep user logged in offline if they were previously authenticated
    final wasLoggedIn = storage.read('isLoggedIn') ?? false;
    if (wasLoggedIn) {
      isAuthenticated(true);
    }
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

  Future<RecordModel?> getCurrentUser() async {
  try {
    if (!pb.authStore.isValid || pb.authStore.record == null) {
      final token = GetStorage().read('authToken');
      final userData = GetStorage().read('userData');
      
      if (token != null && userData != null) {
        pb.authStore.save(token, RecordModel.fromJson(userData));
        await pb.collection('users').authRefresh();
        
        if (!pb.authStore.isValid) {
          Get.toNamed('/login');
          return null;
        }
      }
    }
    return pb.authStore.record;
  } catch (e) {
    Get.snackbar(
      'Connection Error',
      'Unable to connect to server. Please check your internet connection.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return null;
  }
}



  bool get isLoggedIn => isAuthenticated.value;

  void logout() {
  pb.authStore.clear();
  storage.write('isLoggedIn', false);
  storage.remove('authToken');
  storage.remove('userData');
  isAuthenticated(false);
  
  // Only navigate if GetX is properly initialized
  if (Get.isRegistered<GetMaterialApp>()) {
    Get.offAllNamed('/login');
  }
}

}
