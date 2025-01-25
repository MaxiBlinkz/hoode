import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/services/authservice.dart';
import '../../data/services/db_helper.dart';
import '../../data/services/user_service.dart';
import 'package:pocketbase/pocketbase.dart';

class BecomeAgentController extends GetxController {
  final currentStep = 0.obs;
  final steps = ['Basic Info', 'Professional Details', 'Specializations', 'Review'].obs;
  final agentFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final userService = Get.find<UserService>();
  final authService = Get.find<AuthService>();
  final pb = PocketBase(DbHelper.getPocketbaseUrl());

  // Form Controllers
  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final bioController = TextEditingController();
  final licenseController = TextEditingController();
  final contactController = TextEditingController();
  final experienceController = TextEditingController();
  final websiteController = TextEditingController();

  final selectedSpecializations = <String>[].obs;
  final specializations = [
    'Residential',
    'Commercial',
    'Luxury Properties',
    'Industrial',
    'Land Development',
    'Property Management',
    'Investment Properties',
    'New Construction',
    'Vacation Homes',
    'International',
  ];

  final certifications = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void nextStep() {
    if (currentStep.value < steps.length - 1 && validateCurrentStep()) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  bool validateCurrentStep() {
    return agentFormKey.currentState?.validate() ?? false;
  }

  void toggleSpecialization(String spec) {
    if (selectedSpecializations.contains(spec)) {
      selectedSpecializations.remove(spec);
    } else {
      selectedSpecializations.add(spec);
    }
  }

  void addCertification(String cert) {
    certifications.add(cert);
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
