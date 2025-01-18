import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:osm_search_and_pick/open_street_map_search_and_pick.dart';
import '../nav_bar/nav_bar_page.dart';

class UserPreferenceController extends GetxController {
  final priceRange = RangeValues(0.0, 500000.0).obs;
  final selectedTypes = <String>[].obs;
  final selectedAmenities = <String>[].obs;
  final notificationsEnabled = true.obs;
  final locationRadius = 10.0.obs;
  final locationLatitude = 0.0.obs;
  final locationLongitude = 0.0.obs;
  final address = "".obs;

  Logger logger = Logger();

  void updatePriceRange(RangeValues values) => priceRange.value = values;
  void togglePropertyType(String type) {
    if (selectedTypes.contains(type)) {
      selectedTypes.remove(type);
    } else {
      selectedTypes.add(type);
    }
  }

  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
  }

  Future<void> savePreferences() async {
    // Save to local storage and/or backend
    Get.snackbar(
      "Success",
      "Your preferences have been saved",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.offAll(() => NavBarPage());
  }

  void setDefaultLocation() async {
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
      locationLatitude.value = position.latitude;
      locationLongitude.value = position.longitude;

      // Show map dialog for precise location selection
      Get.dialog(
        Dialog(
          child: SizedBox(
            height: MediaQuery.of(Get.context!).size.height * 0.8,
            width: MediaQuery.of(Get.context!).size.width,
            child: OpenStreetMapSearchAndPick(
                // center: LatLong(23, 89),
                buttonColor: Colors.blue,
                buttonText: 'Set Current Location',
                onPicked: (pickedData) {
                  locationLatitude(pickedData.latLong.latitude);
                  locationLongitude(pickedData.latLong.longitude);
                  address(pickedData.addressName);
                }),

            
          ),
        ),
      );
    }
  }
}
