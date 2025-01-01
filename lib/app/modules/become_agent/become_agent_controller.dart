import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hoode/app/data/services/authservice.dart';
import '../../data/services/db_helper.dart';
import '../../data/services/user_service.dart';
import 'package:pocketbase/pocketbase.dart';

class BecomeAgentController extends GetxController {
  //final agentFormKey = GlobalKey<FormState>().obs;
  final userService = Get.find<UserService>();
  final authService = Get.find<AuthService>();
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  final isLoading = false.obs;

  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final bioController = TextEditingController();
  final licenseController = TextEditingController();
  final contactController = TextEditingController();

  final selectedSpecializations = <String>[].obs;
  final specializations = [
    'Residential',
    'Commercial',
    'Luxury',
    'Industrial',
    'Land',
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void toggleSpecialization(String spec) {
    if (selectedSpecializations.contains(spec)) {
      selectedSpecializations.remove(spec);
    } else {
      selectedSpecializations.add(spec);
    }
    update();
  }

  Future<void> submitAgentApplication() async {
    
    isLoading(true);
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null) return;

      await userService.upgradeUserToAgent(
        currentUser.id,
        {
          'name': nameController.text,
          'title': titleController.text,
          'bio': bioController.text,
          'specializations': selectedSpecializations,
          'license': licenseController.text,
          'contact': contactController.text,
          'isAgent': true,
        },
      );

      Get.offAllNamed('/dashboard');
      Get.snackbar(
        'Success',
        'Your agent profile has been created',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create agent profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
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


  @override
  void onClose() {
    nameController.dispose();
    titleController.dispose();
    bioController.dispose();
    licenseController.dispose();
    contactController.dispose();
    super.onClose();
  }
}
