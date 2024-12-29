import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:latlong2/latlong.dart';
import '../../data/enums/enums.dart';

class EditProfileController extends GetxController {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final contactInfoController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final locationController = TextEditingController();
  
  final selectedImage = Rxn<File>();
  final selectedLocation = Rxn<LatLng>();
  final status = Status.initial.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentProfile();
  }

  Future<void> loadCurrentProfile() async {
    // Load current user profile data and populate controllers
  }

  Future<void> getImage() async {
    // Image picker implementation
  }

  Future<void> getCurrentLocation() async {
    // Location picker implementation
  }

  Future<void> updateProfile() async {
    status(Status.loading);
    try {
      // Update profile logic
      status(Status.success);
      Get.back();
    } catch (e) {
      status(Status.error);
    }
  }
}
