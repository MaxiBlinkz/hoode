import 'dart:math' as Math;

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/supabase_service.dart';
import 'package:logger/logger.dart';

class ListingSearchController extends GetxController {
  // Supabase client
  SupabaseClient get _client => SupabaseService.to.client;
  final logger = Logger();

  // Controllers
  final searchController = TextEditingController();
  final locationController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final searchResults = <Map<String, dynamic>>[].obs;
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
          timestamp: DateTime.now());
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
        locationAddress.value =
            '${place.street}, ${place.locality}, ${place.country}';
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
        timestamp: DateTime.now());
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
      
      // Start building the query
      var query = _client.from('properties').select();
      
      // Apply price range filter
      query = query
          .gte('price', priceRange.value.start)
          .lte('price', priceRange.value.end);
      
      // Apply bedroom filter if specified
      if (bedrooms.value > 0) {
        query = query.gte('bedrooms', bedrooms.value);
      }
      
      // Apply bathroom filter if specified
      if (bathrooms.value > 0) {
        query = query.gte('bathrooms', bathrooms.value);
      }
      
      // Apply title search if specified
      if (searchController.text.isNotEmpty) {
        query = query.ilike('title', '%${searchController.text}%');
      }
      
      // Execute the query
      final results = await query;
      
      // If location is available, sort results by distance
      if (location != null) {
        // Sort results by distance (this would ideally use PostGIS in Supabase)
        // For now, we'll sort client-side
        results.sort((a, b) {
          final aLat = a['latitude'] as double?;
          final aLng = a['longitude'] as double?;
          final bLat = b['latitude'] as double?;
          final bLng = b['longitude'] as double?;
          
          if (aLat != null && aLng != null && bLat != null && bLng != null) {
            final aDist = _calculateDistance(
              location.latitude, location.longitude, aLat, aLng);
            final bDist = _calculateDistance(
              location.latitude, location.longitude, bLat, bLng);
            return aDist.compareTo(bDist);
          }
          return 0;
        });
      } else {
        // Sort by creation date if no location
        results.sort((a, b) => 
          (b['created_at'] ?? '').compareTo(a['created_at'] ?? ''));
      }
      
      searchResults.value = results;
    } catch (e) {
      logger.e('Search error: $e');
      Get.snackbar('Search Error', 'Failed to perform search');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Helper method to calculate distance between two points using Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 - 
      (Math.cos((lat2 - lat1) * p) / 2) + 
      (Math.cos(lat1 * p) * Math.cos(lat2 * p) * 
      (1 - Math.cos((lon2 - lon1) * p)) / 2);
    return 12742 * Math.asin(Math.sqrt(a)); // 2 * R; R = 6371 km
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
