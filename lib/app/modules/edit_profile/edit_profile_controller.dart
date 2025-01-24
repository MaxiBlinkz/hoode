import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
  final bioController = TextEditingController();
  
  final selectedImage = Rxn<File>();
  final selectedLocation = Rxn<LatLng>();
  final status = Status.initial.obs;
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Future<void> getImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Photo',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
          ),
        ],
      );

      if (croppedFile != null) {
        selectedImage.value = File(croppedFile.path);
      }
    }
  }

  Future<void> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    selectedLocation.value = LatLng(position.latitude, position.longitude);
    locationController.text = 'Location Updated';
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading(true);
    try {
      // Profile update logic
      Get.back();
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
