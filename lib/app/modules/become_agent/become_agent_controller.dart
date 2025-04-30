import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/authservice.dart';
import '../../data/services/user_service.dart';
import '../../data/services/supabase_service.dart';
import 'package:logger/logger.dart';

class BecomeAgentController extends GetxController {
  // Step management
  final currentStep = 0.obs;
  final steps = ['Basic Info', 'Professional Details', 'Specializations', 'Review'].obs;
  
  // Form key and loading state
  final agentFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  
  // Services
  final userService = Get.find<UserService>();
  final authService = Get.find<AuthService>();
  final logger = Logger();
  
  // Supabase client
  SupabaseClient get _client => SupabaseService.to.client;
  
  // Form Controllers
  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final bioController = TextEditingController();
  final licenseController = TextEditingController();
  final contactController = TextEditingController();
  final experienceController = TextEditingController();
  final websiteController = TextEditingController();
  
  // Specializations
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
  
  // Certifications
  final certifications = <String>[].obs;
  final certificationController = TextEditingController();
  
  // Profile image
  final profileImage = Rxn<File>();
  final hasProfileImage = false.obs;
  
  // Form validation states
  final isBasicInfoValid = false.obs;
  final isProfessionalDetailsValid = false.obs;
  final isSpecializationsValid = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Pre-fill form with existing user data if available
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    try {
      isLoading(true);
      
      final userData = await authService.userProfile.value;
      if (userData != null) {
        nameController.text = userData['full_name'] ?? '';
        contactController.text = userData['contact_info'] ?? '';
      }
    } catch (e) {
      logger.e('Error loading user data: $e');
    } finally {
      isLoading(false);
    }
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
    switch (currentStep.value) {
      case 0: // Basic Info
        final isValid = agentFormKey.currentState?.validate() ?? false;
        isBasicInfoValid(isValid);
        return isValid;
      case 1: // Professional Details
        final isValid = agentFormKey.currentState?.validate() ?? false;
        isProfessionalDetailsValid(isValid);
        return isValid;
      case 2: // Specializations
        final isValid = selectedSpecializations.isNotEmpty;
        isSpecializationsValid(isValid);
        if (!isValid) {
          Get.snackbar(
            'Validation Error',
            'Please select at least one specialization',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        return isValid;
      default:
        return true;
    }
  }
  
  void toggleSpecialization(String spec) {
    if (selectedSpecializations.contains(spec)) {
      selectedSpecializations.remove(spec);
    } else {
      selectedSpecializations.add(spec);
    }
  }
  
  void addCertification() {
    final cert = certificationController.text.trim();
    if (cert.isNotEmpty && !certifications.contains(cert)) {
      certifications.add(cert);
      certificationController.clear();
    }
  }
  
  void removeCertification(String cert) {
    certifications.remove(cert);
  }
  
  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    
    if (image != null) {
      profileImage.value = File(image.path);
      hasProfileImage(true);
    }
  }
  
  Future<void> submitAgentApplication() async {
    if (!validateAllSteps()) {
      Get.snackbar(
        'Validation Error',
        'Please complete all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    isSubmitting(true);
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      
      // 1. Update user profile to mark as agent
      await _client
          .from('users')
          .update({
            'is_agent': true,
            'full_name': nameController.text,
            'contact_info': contactController.text,
          })
          .eq('id', currentUser.id);
      
      // 2. Create agent profile
      final agentProfile = {
        'user_id': currentUser.id,
        'title': titleController.text,
        'bio': bioController.text,
        'license_number': licenseController.text,
        'experience_years': int.tryParse(experienceController.text) ?? 0,
        'website': websiteController.text,
        'specializations': selectedSpecializations,
        'certifications': certifications,
      };
      
      await _client.from('agent_profiles').insert(agentProfile);
      
      // 3. Upload profile image if selected
      if (profileImage.value != null) {
        final imagePath = 'agent_profiles/${currentUser.id}/profile.jpg';
        await _client.storage
            .from('profile_images')
            .upload(
              imagePath,
              profileImage.value!,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            );
            
        // Update profile with image URL
        final imageUrl = _client.storage.from('profile_images').getPublicUrl(imagePath);
        await _client
            .from('agent_profiles')
            .update({'profile_image': imageUrl})
            .eq('user_id', currentUser.id);
      }
      
      // 4. Success and navigation
      Get.offAllNamed('/dashboard');
      Get.snackbar(
        'Success',
        'Your agent profile has been created',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      logger.e('Error creating agent profile: $e');
      Get.snackbar(
        'Error',
        'Failed to create agent profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting(false);
    }
  }
  
  bool validateAllSteps() {
    // Validate all steps at once for final submission
    bool isValid = true;
    
    // Basic Info validation
    if (nameController.text.isEmpty || contactController.text.isEmpty) {
      isValid = false;
      isBasicInfoValid(false);
    } else {
      isBasicInfoValid(true);
    }
    
    // Professional Details validation
    if (licenseController.text.isEmpty || 
        bioController.text.isEmpty || 
        experienceController.text.isEmpty) {
      isValid = false;
      isProfessionalDetailsValid(false);
    } else {
      isProfessionalDetailsValid(true);
    }
    
    // Specializations validation
    if (selectedSpecializations.isEmpty) {
      isValid = false;
      isSpecializationsValid(false);
    } else {
      isSpecializationsValid(true);
    }
    
    return isValid;
  }

  @override
  void onClose() {
    nameController.dispose();
    titleController.dispose();
    bioController.dispose();
    licenseController.dispose();
    contactController.dispose();
    experienceController.dispose();
    websiteController.dispose();
    certificationController.dispose();
    super.onClose();
  }
}
