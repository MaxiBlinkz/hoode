import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/register/register_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

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
  var id = "".obs;
  //var image = "";

  var status = Status.pending.obs;
  final Logger logger = Logger(printer: PrettyPrinter());

  Rx<Object> err = "".obs;

  final pb = PocketBase(POCKETBASE_URL);

  final regController = RegisterController();
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  var imagePath = "";

  void setCountry(String value) {
    country(value);
  }

  void setState(String value) {
    state(value);
  }

  void setTown(String value) {
    town(value);
  }

  Future<void> getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
          WebUiSettings(
            context: Get.context!,
            presentStyle: WebPresentStyle.dialog,
            size: const CropperSize(width: 300, height: 300),
          ),
        ],
      );

      if (croppedFile != null) {
        final bytes = await croppedFile.readAsBytes();
        final png = await convertImageToPng(bytes);
        selectedImage.value = File(croppedFile.path)..writeAsBytesSync(png);
        Get.snackbar(
            "Image Selected", "Image successfully cropped and selected",
            snackPosition: SnackPosition.BOTTOM,
            snackStyle: SnackStyle.FLOATING);
      }
    }
  }

  Future<Uint8List> convertImageToPng(Uint8List imageBytes) async {
    final img.Image? image = img.decodeImage(imageBytes);
    List<int> pngBytes = img.encodePng(image!);
    return Uint8List.fromList(pngBytes);
  }

  Future<void> saveProfile() async {
    status(Status.loading);

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
        final avatarFile = http.MultipartFile.fromString(
          'avatar',
          selectedImage.value!.path,
          filename: 'avatar.jpg',
        );

        await pb.collection('users').update(
          id.value,
          body: body,
          files: [avatarFile],
        );
      } else {
        await pb.collection('users').update(id.value, body: body);
      }

      logger.i(selectedImage.value!.path);

      if (pb.authStore.isValid) {
        status(Status.success);
      } else {
        status(Status.pending);
      }
    } catch (e) {
      status(Status.error);
      logger.i('${status.value}');
      logger.e('$e');
      Get.snackbar("Error Saving Profile", "$e",
          snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
    }
    update();
  }

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
    id(Get.arguments['id']);
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
