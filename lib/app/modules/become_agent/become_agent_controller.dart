import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/services/db_helper.dart';
import 'package:hoode/app/data/services/user_service.dart';
import 'package:pocketbase/pocketbase.dart';

class BecomeAgentController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final userService = Get.find<UserService>();
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

  void toggleSpecialization(String spec) {
    if (selectedSpecializations.contains(spec)) {
      selectedSpecializations.remove(spec);
    } else {
      selectedSpecializations.add(spec);
    }
  }

  Future<void> submitAgentApplication() async {
  if (formKey.currentState == null) return;
  if (!formKey.currentState!.validate()) return;
    
  isLoading(true);
  try {
    final currentUser = pb.authStore.record;
    if (currentUser == null) {
      Get.snackbar('Error', 'Please login first');
      return;
    }

    await userService.upgradeUserToAgent(
      currentUser.id,
      {
        'name': nameController.text,
        'title': titleController.text,
        'bio': bioController.text,
        'specializations': selectedSpecializations,
        'license': licenseController.text,
        'contact': contactController.text,
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
      'Failed to create agent profile',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading(false);
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

