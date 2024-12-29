import 'dart:io';
// import 'package:bugsnag_flutter/bugsnag_flutter.dart' as bugnag;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/register/register_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:osm_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:hoode/app/data/services/db_helper.dart';

class ProfileSetupController extends GetxController {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController contactInfoController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  

  var firstname = "".obs;
  var lastname = "".obs;
  var contactInfo = "".obs;
  var country = "".obs;
  var state = "".obs;
  var city = "".obs;
  var location = "".obs;
  var id = "".obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final address = "".obs;

  final Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);

  var status = Status.initial.obs;
  final Logger logger = Logger(printer: PrettyPrinter());
  final storage = GetStorage();

  Rx<Object> err = "".obs;

  // final pb = PocketBase(POCKETBASE_URL);
  final pb = PocketBase(DbHelper.getPocketbaseUrl());

  RecordModel user = RecordModel();

  final regController = RegisterController();
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  var imagePath = "";

  void setCountry(String? value) {
    if (value != null) {
      country(value);
    }
  }

  void setState(String? value) {
    if (value != null) {
      state(value);
    }
  }

  void setCity(String? value) {
    if (value != null) {
      city(value);
    }
  }

  Future<void> getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (!Platform.isWindows) {
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
    } else {
      if (image != null) {
        final bytes = await image.readAsBytes();
        final png = await convertImageToPng(bytes);
        selectedImage.value = File(image.path)..writeAsBytesSync(png);
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
      "city": city.value,
      "address": address.value,
      "longitude": longitude.value,
      "lattitude": latitude.value,
    };

    try {
      if (selectedImage.value != null) {
        final avatarBytes = await selectedImage.value!.readAsBytes();
        final avatarFile = http.MultipartFile.fromBytes(
          'avatar',
          avatarBytes,
          filename: 'avatar.png',
        );

        logger.i(
            'Avatar Filename: ${avatarFile.filename}, \nAvatar File:${selectedImage.value!.readAsBytes().toString()}'); // Debug logging
        logger.i('User ID: ${id.value}'); // Add this before the update call

        // LETS CHECK IF THE TOKEN IS ACTIVE ELSE WE AUTHENTICATE
        logger.i('IS TOKEN ACTIVE: ${pb.authStore.isValid}');

        user = await pb.collection('users').update(
          id.value,
          body: body,
          files: [avatarFile],
        );
        logger.i('Update successful: ${user.toString()}');
      } else {
        final result =
            await pb.collection('users').update(id.value, body: body);
        logger.i('Update successful: ${result.toString()}');
      }

      if (pb.authStore.isValid) {
        status(Status.success);
      } else {
        status(Status.initial);
      }
    } catch (e) {
      status(Status.error);
      logger.e('Error saving profile: $e'); // Log the error
      Get.snackbar("Error Saving Profile", "$e",
          snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
      // await bugnag.bugsnag.notify(e, stack);
    }
    update();
  }

  Future<void> setCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Location Required',
        'Please enable location services in your device settings',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final position = await Geolocator.getCurrentPosition();
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Show map dialog for precise location selection
      Get.dialog(
        Dialog(
          child: SizedBox(
            height: MediaQuery.of(Get.context!).size.height * 0.8,
            width: MediaQuery.of(Get.context!).size.width * 0.8,
            child: OpenStreetMapSearchAndPick(
                // center: LatLong(23, 89),
                buttonColor: Colors.blue,
                buttonText: 'Set Current Location',
                onPicked: (pickedData) {
                  latitude(pickedData.latLong.latitude);
                  longitude(pickedData.latLong.longitude);
                  address(pickedData.addressName);
                  address(pickedData.addressName);
                }),
          ),
        ),
      );
    }
  }


  void initControllers() {
    firstnameController
        .addListener(() => firstname.value = firstnameController.text);
    lastnameController
        .addListener(() => lastname.value = lastnameController.text);
    contactInfoController
        .addListener(() => contactInfo.value = contactInfoController.text);
    countryController
        .addListener(() => country.value = countryController.text);
    stateController
        .addListener(() => state.value = stateController.text);
    cityController
        .addListener(() => city.value = cityController.text);
  }

  @override
  void onInit() {
    super.onInit();
    id(Get.arguments['id']);
    initControllers();
    final token = storage.read('token');
    if (token != null) {
      pb.authStore.save(token, user);
    }
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
