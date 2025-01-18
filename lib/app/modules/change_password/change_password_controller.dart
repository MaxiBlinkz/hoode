import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/services/db_helper.dart';
import 'package:pocketbase/pocketbase.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final pb = PocketBase(DbHelper.getPocketbaseUrl());

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading(true);
    try {
      await pb.collection('users').confirmPasswordReset(
        currentPasswordController.text,
        newPasswordController.text,
        confirmPasswordController.text,
      );
      
      Get.snackbar(
        'Success',
        'Password changed successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }



  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

}
