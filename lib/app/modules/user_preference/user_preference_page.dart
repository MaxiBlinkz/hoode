import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';

import 'user_preference_controller.dart';

class UserPreferencePage extends GetView<UserPreferenceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Set Your Preferences",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildPriceRangeSlider(),
                      _buildPropertyTypeSelector(),
                      _buildAmenitiesSelector(),
                      _buildLocationPreference(),
                      _buildNotificationPreferences(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: controller.savePreferences,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        child: const Text("Save Preferences"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Price Range"),
        Obx(() => RangeSlider(
          values: controller.priceRange.value,
          min: 0,
          max: 1000000,
          onChanged: controller.updatePriceRange,
        )),
      ],
    );
  }

  Widget _buildPropertyTypeSelector() {
    return Wrap(
      spacing: 8,
      children: [
        "House",
        "Apartment",
        "Villa",
        "Land"
      ].map((type) => Obx(() => FilterChip(
        selected: controller.selectedTypes.contains(type),
        onSelected: (selected) => controller.togglePropertyType(type),
        label: Text(type),
      ))).toList(),
    );
  }
  Widget _buildLocationPreference() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Search Radius (km)"),
      Obx(() => Slider(
        value: controller.locationRadius.value,
        min: 1,
        max: 50,
        divisions: 49,
        label: "${controller.locationRadius.value.round()} km",
        onChanged: (value) => controller.locationRadius.value = value,
      )),
      ListTile(
        leading: const Icon(IconlyLight.location),
        title: const Text("Set Default Location"),
        trailing: const Icon(IconlyLight.arrowRight2),
        onTap: () => controller.setDefaultLocation(),
      ),
    ],
  );
}

Widget _buildNotificationPreferences() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Notifications"),
      SwitchListTile(
        title: const Text("Price Alerts"),
        value: controller.notificationsEnabled.value,
        onChanged: (value) => controller.notificationsEnabled.value = value,
      ),
      SwitchListTile(
        title: const Text("New Properties"),
        value: controller.notificationsEnabled.value,
        onChanged: (value) => controller.notificationsEnabled.value = value,
      ),
      SwitchListTile(
        title: const Text("Market Updates"),
        value: controller.notificationsEnabled.value,
        onChanged: (value) => controller.notificationsEnabled.value = value,
      ),
    ],
  );
}


  Widget _buildAmenitiesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Must-Have Amenities"),
        Wrap(
          spacing: 8,
          children: [
            "Pool",
            "Parking",
            "Gym",
            "Security",
            "Garden"
          ].map((amenity) => Obx(() => FilterChip(
            selected: controller.selectedAmenities.contains(amenity),
            onSelected: (selected) => controller.toggleAmenity(amenity),
            label: Text(amenity),
          ))).toList(),
        ),
      ],
    );
  }
}

