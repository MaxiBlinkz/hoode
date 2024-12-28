import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';
import 'package:latlong2/latlong.dart';

class UserPreferenceController extends GetxController {
  final priceRange = RangeValues(0.0, 500000.0).obs;
  final selectedTypes = <String>[].obs;
  final selectedAmenities = <String>[].obs;
  final notificationsEnabled = true.obs;
  final locationRadius = 10.0.obs;
  final locationLatitude = 0.0.obs;
  final locationLongitude = 0.0.obs;

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
            height: 400,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(position.latitude, position.longitude),
                initialZoom: 13,
                onTap: (tapPosition, point) {
                  locationLatitude.value = point.latitude;
                  locationLongitude.value = point.longitude;
                  Get.back();
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                          locationLatitude.value, locationLongitude.value),
                      width: 30,
                      height: 30,
                      child: Icon(Icons.location_pin, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
