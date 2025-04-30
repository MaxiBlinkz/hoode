import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hoode/app/data/services/api_service.dart';
import '../../data/services/bookmarkservice.dart';
import '../../data/services/supabase_service.dart';
import '../../core/algorithms/models/geo_point.dart';
import '../../core/algorithms/models/market_trends.dart';
import '../../core/algorithms/models/seasonal_data.dart';
import '../../core/algorithms/models/user_interaction_history.dart';
import '../../core/algorithms/models/user_preferences.dart';
import '../../data/enums/enums.dart';
import '../../../core.dart';
import 'package:logger/logger.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math' as Math;

class HomeController extends GetxController {
  // Properties
  final properties = <Map<String, dynamic>>[].obs;
  final featuredProperties = <Map<String, dynamic>>[].obs;
  final filteredProperties = <Map<String, dynamic>>[].obs;
  final recommendedProperties = <Map<String, dynamic>>[].obs;
  final pricePredictions = <String, double>{}.obs;

  // State variables
  final isLoading = true.obs;
  final status = Status.initial.obs;
  final hasMoreData = true.obs;
  final totalItems = 0.obs;
  final isLoadingMore = false.obs;
  final hasError = false.obs;
  final searchQuery = ''.obs;
  final selectedFilter = RxString('');
  
  // Pagination
  int currentPage = 1;
  final int perPage = 20;

  // Services
  final supabaseService = SupabaseService.to;
  final bookmarkService = Get.find<BookmarkService>();
  final ApiService _apiService = ApiService();
  final logger = Logger();

  // Controllers
  final listController = ScrollController();

  // Get Supabase client
  SupabaseClient get _client => supabaseService.client;

  @override
  void onInit() {
    super.onInit();
    
    // Load data
    loadProperties();
    loadRecommendations();
    loadFeaturedProperties();
    
    // Setup scroll listener for pagination
    _setupScrollListener();
  }

  Future<void> loadFeaturedProperties() async {
    try {
      final response = await _client
          .from('properties')
          .select()
          .eq('featured', true)
          .order('created_at', ascending: false)
          .limit(5);

      featuredProperties.value = response;
    } catch (e) {
      logger.e('Error loading featured properties: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getProperties(int page) async* {
    status(Status.loading);
    isLoading(true);
    hasError(false);
    
    try {
      // Get current user
      final currentUser = _client.auth.currentUser;

      // Build query
      var query = _client
          .from('properties')
          .select()
          .range((page - 1) * perPage, page * perPage - 1);

      // Add search filter if provided
      if (searchQuery.isNotEmpty) {
        final searchTerm = '%${searchQuery.value}%';
        query = _client
            .from('properties')
            .select()
            .or('title.ilike.$searchTerm,location.ilike.$searchTerm')
            .range((page - 1) * perPage, page * perPage - 1);
      }

      
      // Execute query
      final response = await query;

      // Get total count for pagination
      final countResponse = await _client
          .from('properties')
          .select('id')
          .count(CountOption.exact);

      totalItems(countResponse.count ?? 0);
      hasMoreData(properties.length < totalItems.value);
      
      // Sort properties by distance if user location is available
      final List<Map<String, dynamic>> sortedItems = List.from(response);

      // Get user's location if available
      GeoPoint? userLocation;
      if (currentUser != null) {
        final userProfile = await _client
            .from('users')
            .select()
            .eq('id', currentUser.id)
            .single();

        if (userProfile != null &&
            userProfile['country'] != null &&
            userProfile['state'] != null &&
            userProfile['city'] != null) {
          userLocation = await _getGeoPointFromLocation(userProfile['country'],
              userProfile['state'], userProfile['city']);
        }
      }
      
      // Sort by distance if user location is available, otherwise by creation date
      if (userLocation != null) {
        sortedItems.sort((a, b) {
          final aGeoPoint = _getGeoPointFromProperty(a);
          final bGeoPoint = _getGeoPointFromProperty(b);

          if (aGeoPoint != null && bGeoPoint != null) {
            final aDistance = _calculateDistance(userLocation!, aGeoPoint);
            final bDistance = _calculateDistance(userLocation!, bGeoPoint);

            return aDistance.compareTo(bDistance);
          } else {
            return 0;
          }
        });
      } else {
        sortedItems.sort(
            (b, a) => (a['created_at'] ?? '').compareTo(b['created_at'] ?? ''));
      }

      yield sortedItems;
      status(Status.success);
      isLoading(false);
      update();
    } catch (e) {
      status(Status.error);
      hasError(true);
      logger.e('Error fetching properties: $e');
      yield [];
    }
  }

  // Function to calculate distance using Haversine formula
  double _calculateDistance(GeoPoint p1, GeoPoint p2) {
    const double earthRadius = 6371; // Radius of Earth in kilometers

    final double lat1Rad = _degreesToRadians(p1.latitude);
    final double lon1Rad = _degreesToRadians(p1.longitude);
    final double lat2Rad = _degreesToRadians(p2.latitude);
    final double lon2Rad = _degreesToRadians(p2.longitude);

    final double latDiff = lat2Rad - lat1Rad;
    final double lonDiff = lon2Rad - lon1Rad;

    final double a = Math.sin(latDiff / 2) * Math.sin(latDiff / 2) +
        Math.cos(lat1Rad) *
            Math.cos(lat2Rad) *
            Math.sin(lonDiff / 2) *
            Math.sin(lonDiff / 2);
    final double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * Math.pi / 180;
  }

  // Helper function to get GeoPoint from a property
  GeoPoint? _getGeoPointFromProperty(Map<String, dynamic> property) {
    final latitude = property['latitude'];
    final longitude = property['longitude'];

    if (latitude is double && longitude is double) {
      return GeoPoint(latitude: latitude, longitude: longitude);
    } else {
      return null;
    }
  }

  Future<GeoPoint?> _getGeoPointFromLocation(String country, String state, String city) async {
    try {
      List<Location> locations =
          await locationFromAddress("$city, $state, $country");
      if (locations.isNotEmpty) {
        return GeoPoint(
            latitude: locations.first.latitude,
            longitude: locations.first.longitude);
      }
      return null;
    } catch (e) {
      logger.e('Error getting geocode: $e');
      return null;
    }
  }

  void searchProperties(String query) {
    searchQuery.value = query;
    loadProperties();
  }

  Future<void> loadProperties() async {
    properties.clear();
    filteredProperties.clear();
    currentPage = 1;
    
    // Ensure bookmarks are loaded
    await bookmarkService.loadBookmarks();
    
    // Load properties
    getProperties(currentPage).listen((data) {
      properties(data);
      filterProperties(selectedFilter.value);
    });
  }

  void refreshAfterBookmarkChange() {
    // No need to reload all properties, just update the UI
    update();
  }

  void retryLoading() {
    loadProperties();
  }

  void _setupScrollListener() {
    listController.addListener(() {
      if (!listController.hasClients) return;
      
      final maxScroll = listController.position.maxScrollExtent;
      final currentScroll = listController.position.pixels;
      const threshold = 200;
      
      if ((maxScroll - currentScroll) <= threshold &&
          !isLoadingMore.value &&
          hasMoreData.value) {
        isLoadingMore(true);
        currentPage++;
        
        getProperties(currentPage).listen(
          (data) {
            if (data.isEmpty) {
              hasMoreData(false);
            } else {
              properties.addAll(data);
              filterProperties(selectedFilter.value);
            }
            isLoadingMore(false);
          },
          onError: (error) {
            isLoadingMore(false);
            logger.e('Error loading more properties: $error');
          },
        );
      }
    });
  }

  Future<void> loadRecommendations() async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) return;

      // Get user profile for location data
      final userProfile = await _client
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .single();

      if (userProfile == null) return;

      // Get user's latitude and longitude
      final userLatitude = userProfile['latitude'] ?? 0.0;
      final userLongitude = userProfile['longitude'] ?? 0.0;

      // Get recommendations from API service
      final recommendations = await _apiService.getRecommendations(
        userId: currentUser.id,
        latitude: userLatitude,
        longitude: userLongitude,
      );
      
      // Process recommendations if needed
      // ...
      
    } catch (e) {
      logger.e('Error loading recommendations: $e');
    }
  }

  Future<void> viewProperty(String propertyId) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) return;

      // Track property view
      await _apiService.trackPropertyView(
        currentUser.id,
        propertyId,
      );
      
      // // Increment view count in properties table
      // await _client.rpc('increment_view_count', params: {
      //   'row_id': propertyId,
      //   'column_name': 'view_count',
      //   'amount': 1
      // });

      // Fetch the current property to get the view count
      final property = await _client
          .from('properties')
          .select('view_count')
          .eq('id', propertyId)
          .single();

// Increment the view count
      final currentViewCount = property['view_count'] as int? ?? 0;
      await _client
          .from('properties')
          .update({'view_count': currentViewCount + 1}).eq('id', propertyId);

      // Record user interaction
      await _client.from('user_interactions').insert({
        'user_id': currentUser.id,
        'property_id': propertyId,
        'interaction_type': 'view',
        'created_at': DateTime.now().toIso8601String(),
      });
      
    } catch (e) {
      logger.e('Error tracking property view: $e');
    }
  }

  void filterProperties(String category) {
    selectedFilter.value = category;
    
    if (category.isEmpty) {
      filteredProperties.value = properties.toList();
      return;
    }
    
    filteredProperties.value = properties.where((property) {
      return property['category']?.toString().toLowerCase() == 
          category.toLowerCase();
    }).toList();
  }

  @override
  void onClose() {
    listController.dispose();
    super.onClose();
  }
}
