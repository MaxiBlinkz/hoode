import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/register/register_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';

class ProfileSetupController extends GetxController {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController contactInfoController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  var firstname = "".obs;
  var lastname = "".obs;
  var contactInfo = "".obs;
  var country = "".obs;
  var state = "".obs;
  var town = "".obs;
  var location = "".obs;
  //var image = "";

  var status = Status.pending.obs;
  final Logger logger = Logger(printer: PrettyPrinter());

  Rx<Object> err = "".obs;

  final pb = PocketBase(POCKETBASE_LOCAL_URL);

  final regController = RegisterController();
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  var imagePath = "";

  set setCountry(String value) {
    country(value);
  }

  set setState(String value) {
    state(value);
  }

  set setTown(String value) {
    town(value);
  }

  // Future<void> getImage() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     selectedImage.value = File(image.path);
  //     Get.snackbar("Image Selected", "Image successfully selected",
  //         snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
  //   }
  // }
  

  Future<void> saveProfile() async {
  status(Status.loading);
  final id = regController.id;

  final body = <String, dynamic>{
    "first_name": firstname.value,
    "last_name": lastname.value,
    "country": country.value,
    "contact_info": contactInfo.value,
    "location": location.value,
    "state": state.value,
    "town": town.value
  };

  try {
    if (selectedImage.value != null) {
      final avatarFile = await http.MultipartFile.fromPath(
        'avatar',
        selectedImage.value!.path,
        filename: 'avatar.jpg',
      );

      await pb.collection('users').update(
        id,
        body: body,
        files: [avatarFile],
      );
    } else {
      await pb.collection('users').update(id, body: body);
    }

    if (pb.authStore.isValid) {
      status(Status.success);
    } else {
      status(Status.pending);
    }
  } catch (e) {
    err.value = e;
    status(Status.error);
    logger.i('${status.value}');
    logger.e('$e');
    Get.snackbar("Error Saving Profile", "$e",
          snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
  }
  update();
}

  // Future<void> saveProfile() async {
  //   status(Status.loading);
  //   final id = regController.id;

  //   final body = <String, dynamic>{
  //     "first_name": firstname.value,
  //     "last_name": lastname.value,
  //     "country": country.value,
  //     "contact_info": contactInfo.value,
  //     "location": location.value,
  //     "state": state.value,
  //     "town": town.value
  //   };
  //   final files = [
  //     http.MultipartFile.fromString(
  //       'avatar',
  //       imagePath,
  //       filename: imagePath.split('/').last,
  //     )
  //   ];
  //   print(id);
  //   try {
  //     await pb.collection('users').update(id, body: body, files: files);
  //     if (pb.authStore.isValid) {
  //       status(Status.success);
  //     } else {
  //       status(Status.pending);
  //     }
  //   } catch (e) {
  //     err.value = e;
  //     status(Status.error);
  //     print('\n\n${status.value}\n\n');
  //     print('\n\n${e}\n\n');
  //   }
  //   update();
  // }

  void initControllers() {
    firstnameController
        .addListener(() => firstname.value = firstnameController.text);
    lastnameController
        .addListener(() => lastname.value = lastnameController.text);
    contactInfoController
        .addListener(() => contactInfo.value = contactInfoController.text);
    locationController
        .addListener(() => location.value = locationController.text);
  }

  @override
  void onInit() {
    super.onInit();
    initControllers();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
