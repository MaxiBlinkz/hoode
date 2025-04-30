import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/image_cropper/image_cropper_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:osm_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../data/services/authservice.dart';
import '../../data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

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
  
  final personalInfoFormKey = GlobalKey<FormState>();
  final locationFormKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  var imagePath = "";

  final currentStep = 0.obs;
  final steps = ['Personal Info', 'Location', 'Profile Photo', 'Review'].obs;

  // Get Supabase client from SupabaseService
  SupabaseClient get _client => SupabaseService.to.client;
  final authService = Get.find<AuthService>();

  void nextStep() {
    if (currentStep.value < steps.length - 1) {
      if (validateCurrentStep()) {
        currentStep.value++;
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        return personalInfoFormKey.currentState?.validate() ?? false;
      case 1:
        return locationFormKey.currentState?.validate() ?? false;
      default:
        return true;
    }
  }

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
    if (image != null) {
      final cropResult = await Get.to(() => ImageCropperPage(
            imagePath: image.path,
            aspectRatio: 1.0,
          ));

      if (cropResult != null) {
        selectedImage.value = File(cropResult);
        Get.snackbar("Image Selected", "Image successfully cropped and selected",
            snackPosition: SnackPosition.BOTTOM,
            snackStyle: SnackStyle.FLOATING);
      }
    }
  }

  Future<void> saveProfile() async {
    status(Status.loading);

    final userData = {
      "first_name": firstname.value,
      "last_name": lastname.value,
      "country": country.value,
      "contact_info": contactInfo.value,
      "location": location.value,
      "state": state.value,
      "city": city.value,
      "address": address.value,
      "longitude": longitude.value,
      "latitude": latitude.value,
    };

    try {
      // First update the user profile in the database
      await _client
          .from('users')
          .update(userData)
          .eq('id', id.value);
      
      // If an image was selected, upload it to storage
      if (selectedImage.value != null) {
        final fileExt = path.extension(selectedImage.value!.path);
        final fileName = 'avatar_${id.value}$fileExt';
        
        // Upload the file to Supabase Storage
        await _client.storage.from('avatars').upload(
          fileName,
          selectedImage.value!,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );
        
        // Get the public URL
        final imageUrl = _client.storage.from('avatars').getPublicUrl(fileName);
        
        // Update the user profile with the avatar URL
        await _client
            .from('users')
            .update({'avatar_url': imageUrl})
            .eq('id', id.value);
      }

      status(Status.success);
      Get.offAllNamed('/home');
    } catch (e) {
      status(Status.error);
      logger.e('Error saving profile: $e');
      Get.snackbar("Error Saving Profile", "$e",
          snackPosition: SnackPosition.BOTTOM, snackStyle: SnackStyle.FLOATING);
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
            width: MediaQuery.of(Get.context!).size.width,
            child: OpenStreetMapSearchAndPick(
                buttonColor: Colors.blue,
                buttonText: 'Set Current Location',
                onPicked: (pickedData) {
                  latitude(pickedData.latLong.latitude);
                  longitude(pickedData.latLong.longitude);
                  address(pickedData.addressName);
                  location(pickedData.addressName);
                  Get.back();
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

  Future<void> loadUserData() async {
    try {
      // Get user data from Supabase
      final userData = await _client
          .from('users')
          .select()
          .eq('id', id.value)
          .single();
      
      if (userData != null) {
        // Populate form fields with existing data if available
        if (userData['first_name'] != null) {
          firstname(userData['first_name']);
          firstnameController.text = userData['first_name'];
        }
        
        if (userData['last_name'] != null) {
          lastname(userData['last_name']);
          lastnameController.text = userData['last_name'];
        }
        
        if (userData['contact_info'] != null) {
          contactInfo(userData['contact_info']);
          contactInfoController.text = userData['contact_info'];
        }
        
        if (userData['country'] != null) {
          country(userData['country']);
          countryController.text = userData['country'];
        }
        
        if (userData['state'] != null) {
          state(userData['state']);
          stateController.text = userData['state'];
        }
        
        if (userData['city'] != null) {
          city(userData['city']);
          cityController.text = userData['city'];
        }
        
        if (userData['address'] != null) {
          address(userData['address']);
        }
        
        if (userData['latitude'] != null) {
          latitude(userData['latitude']);
        }
        
        if (userData['longitude'] != null) {
          longitude(userData['longitude']);
        }
      }
    } catch (e) {
      logger.e('Error loading user data: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    id(Get.arguments['id']);
    initControllers();
    loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    firstnameController.dispose();
    lastnameController.dispose();
    contactInfoController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    super.onClose();
  }
}
