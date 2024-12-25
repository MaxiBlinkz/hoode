import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class AddListingController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final title = ''.obs;
  final description = ''.obs;
  final price = 0.0.obs;
  final images = <String>[].obs;
  final isLoading = false.obs;

  Future<void> submitListing() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    try {
      // Submit listing logic
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  void addImage() {
    // Image picker logic
  }
}
