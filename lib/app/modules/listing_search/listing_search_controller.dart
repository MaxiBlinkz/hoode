import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hoode/app/data/services/db_helper.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:logger/logger.dart';

class ListingSearchController extends GetxController {
  // final pb = PocketBase(POCKETBASE_URL);
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  final logger = Logger();
  
  // Controllers
  final searchController = TextEditingController();
  final locationController = TextEditingController();
  
  // Observable states
  final isLoading = false.obs;
  final searchResults = <RecordModel>[].obs;
  final priceRange = RangeValues(0.0, 1000000.0).obs;
  final bedrooms = 0.obs;
  final bathrooms = 0.obs;
  final selectedLocation = Rxn<Location>();
  final userLocation = Rxn<Location>();
  final locationAddress = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  void updateSearchQuery(String query) {
    performSearch();
  }

  Future<void> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      userLocation.value = Location(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now()
      );
      await reverseGeocode(position.latitude, position.longitude);
    } catch (e) {
      logger.e('Error getting current location: $e');
    }
  }

  Future<void> geocodeAddress(String address) async {
    if (address.isEmpty) return;
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        selectedLocation.value = locations.first;
        await performSearch();
      }
    } catch (e) {
      logger.e('Geocoding error: $e');
    }
  }

  Future<void> reverseGeocode(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        locationAddress.value = '${place.street}, ${place.locality}, ${place.country}';
        locationController.text = locationAddress.value;
      }
    } catch (e) {
      logger.e('Reverse geocoding error: $e');
    }
  }

  Future<void> useCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    userLocation.value = Location(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now()
    );
    await reverseGeocode(position.latitude, position.longitude);
    await performSearch();
  }

  void updatePriceRange(RangeValues values) {
    priceRange.value = values;
  }

  Future<void> performSearch() async {
    isLoading.value = true;
    try {
      final location = selectedLocation.value ?? userLocation.value;
      final filters = [
        'price >= ${priceRange.value.start}',
        'price <= ${priceRange.value.end}',
        if (bedrooms > 0) 'bedrooms >= ${bedrooms.value}',
        if (bathrooms > 0) 'bathrooms >= ${bathrooms.value}',
        if (searchController.text.isNotEmpty) 'title ~ "${searchController.text}"'
      ];

      final results = await pb.collection('properties').getList(
        filter: filters.join(' && '),
        sort: location != null ? 
          'distance(location, [${location.latitude}, ${location.longitude}])' : '-created',
      );
      
      searchResults.value = results.items;
    } catch (e) {
      logger.e('Search error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    performSearch();
  }

  @override
  void onClose() {
    searchController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
