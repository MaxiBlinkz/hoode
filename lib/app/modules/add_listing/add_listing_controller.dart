import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:logger/logger.dart';
import 'package:hoode/app/data/services/db_helper.dart';
import 'package:http/http.dart' as http;
import 'package:hoode/app/data/enums/enums.dart';

class AddListingController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final title = ''.obs;
  final description = ''.obs;
  final price = 0.0.obs;
  final category = ''.obs;
  final bedrooms = 0.obs;
  final bathrooms = 0.obs;
  final area = 0.0.obs;
  final address = ''.obs;
  final amenities = <String>[].obs;
  final images = <File>[].obs;
  final isLoading = false.obs;
  final currentStep = 0.obs;
  final _picker = ImagePicker();
  final Logger logger = Logger(printer: PrettyPrinter());
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  var status = Status.initial.obs;

  // final titleController = TextEditingController();

  final availableAmenities = [
    'Parking',
    'Pool',
    'Garden',
    'Security',
    'Gym',
    'Air Conditioning',
    'Furnished',
    'Pet Friendly',
    'Storage',
    'Elevator',
  ];

  final categories = [
    'House',
    'Apartment',
    'Villa',
    'Condo',
    'Townhouse',
    'Studio',
    'Penthouse',
  ];

  void toggleAmenity(String amenity) {
    if (amenities.contains(amenity)) {
      amenities.remove(amenity);
    } else {
      amenities.add(amenity);
    }
  }

  void nextStep() {
  if (formKey.currentState!.validate()) { // GetX validation
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  } else {
    // Show error message as before
    Get.snackbar(
      'Required Fields',
      'Please fill in all required fields before proceeding',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}


  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> addImage() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1920,
    );

    if (pickedFiles != null) {
      images.addAll(pickedFiles.map((xFile) => File(xFile.path)));
      Get.snackbar(
          "Images Selected", "${pickedFiles.length} images added successfully",
          snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
    }
  }

  Future<void> submitListing() async {
    if (!formKey.currentState!.validate()) return;
    if (images.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one image',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    status(Status.loading);
    isLoading.value = true;

    try {
      final body = <String, dynamic>{
        "title": title.value,
        "description": description.value,
        "price": price.value,
        "category": category.value,
        "bedrooms": bedrooms.value,
        "bathrooms": bathrooms.value,
        "area": area.value,
        "address": address.value,
        "amenities": amenities,
      };

      List<http.MultipartFile> imageFiles = [];
      for (var i = 0; i < images.length; i++) {
        final imageBytes = await images[i].readAsBytes();
        final imageFile = http.MultipartFile.fromBytes(
          'images',
          imageBytes,
          filename: 'image_$i.png',
        );
        imageFiles.add(imageFile);
      }

      final record = await pb.collection('listings').create(
            body: body,
            files: imageFiles,
          );

      logger.i('Listing created successfully: ${record.toString()}');
      status(Status.success);
      Get.back();
      Get.snackbar(
        'Success',
        'Listing created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      status(Status.error);
      logger.e('Error creating listing: $e');
      Get.snackbar(
        'Error',
        'Failed to create listing',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  bool validateStep(int step) {
    switch (step) {
      case 0:
        return title.value.isNotEmpty && category.value.isNotEmpty;
      case 1:
        return price.value > 0 && bedrooms.value > 0;
      case 2:
        return amenities.isNotEmpty;
      case 3:
        return images.isNotEmpty;
      default:
        return false;
    }
  }

  // void initControllers() {
  //   titleController.addListener(() => title.value = titleController.text);
  //   // emailController.addListener(() => email.value = emailController.text);
  //   // passwordController
  //   //     .addListener(() => password.value = passwordController.text);
  //   // confirmPasswordController.addListener(
  //   //     () => confirmPassword.value = confirmPasswordController.text);
  // }

  // @override
  // void onInit() {
  //   super.onInit();
  //   initControllers();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   titleController.dispose();
  //   // emailController.dispose();
  //   // passwordController.dispose();
  //   // confirmPasswordController.dispose();
  //   super.onClose();
  // }
}
