import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/theme_controller.dart';
import 'user_preference_controller.dart';

class UserPreferencePage extends GetView<UserPreferenceController> {
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(red: 0, green: 0, blue: 0, alpha: 179),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Set Your Preferences",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withValues(
                                red: 0, green: 0, blue: 0, alpha: 0.2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildPriceRangeSlider(context),
                          _buildPropertyTypeSelector(context),
                          _buildAmenitiesSelector(context),
                          _buildLocationPreference(context),
                          _buildNotificationPreferences(context),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: controller.savePreferences,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
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
          )),
    );
  }

  Widget _buildPriceRangeSlider(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Price Range",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        const SizedBox(height: 8),
        Obx(() => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currencyFormat
                          .format(controller.priceRange.value.start)),
                      Text(currencyFormat
                          .format(controller.priceRange.value.end)),
                    ],
                  ),
                ),
                RangeSlider(
                  values: controller.priceRange.value,
                  min: 0.0,
                  max: 1000000.0,
                  divisions: 100,
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  labels: RangeLabels(
                    currencyFormat.format(controller.priceRange.value.start),
                    currencyFormat.format(controller.priceRange.value.end),
                  ),
                  onChanged: controller.updatePriceRange,
                ),
              ],
            )),
      ],
    );
  }


  Widget _buildPropertyTypeSelector(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: ["House", "Apartment", "Villa", "Land"]
          .map((type) => Obx(() => FilterChip(
                selected: controller.selectedTypes.contains(type),
                onSelected: (selected) => controller.togglePropertyType(type),
                label: Text(type),
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: controller.selectedTypes.contains(type)
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                ),
              )))
          .toList(),
    );
  }

  Widget _buildLocationPreference(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Search Radius (km)",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        Obx(() => Slider(
              value: controller.locationRadius.value,
              min: 1,
              max: 50,
              divisions: 49,
              label: "${controller.locationRadius.value.round()} km",
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(red: 0, green: 0, blue: 0, alpha: 77),
              onChanged: (value) => controller.locationRadius.value = value,
            )),
        ListTile(
          leading: Icon(IconlyLight.location,
              color: Theme.of(context).colorScheme.primary),
          title: Text("Set Default Location"),
          trailing: Icon(IconlyLight.arrowRight2,
              color: Theme.of(context).colorScheme.primary),
          onTap: () => controller.setDefaultLocation(),
        ),
      ],
    );
  }

  Widget _buildNotificationPreferences(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notifications",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        SwitchListTile(
          title: Text("Price Alerts"),
          value: controller.notificationsEnabled.value,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (value) => controller.notificationsEnabled.value = value,
        ),
        SwitchListTile(
          title: Text("New Properties"),
          value: controller.notificationsEnabled.value,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (value) => controller.notificationsEnabled.value = value,
        ),
        SwitchListTile(
          title: Text("Market Updates"),
          value: controller.notificationsEnabled.value,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (value) => controller.notificationsEnabled.value = value,
        ),
      ],
    );
  }

  Widget _buildAmenitiesSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Must-Have Amenities",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        Wrap(
          spacing: 8,
          children: ["Pool", "Parking", "Gym", "Security", "Garden"]
              .map((amenity) => Obx(() => FilterChip(
                    selected: controller.selectedAmenities.contains(amenity),
                    onSelected: (selected) => controller.toggleAmenity(amenity),
                    label: Text(amenity),
                    selectedColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: controller.selectedAmenities.contains(amenity)
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  )))
              .toList(),
        ),
      ],
    );
  }
}
