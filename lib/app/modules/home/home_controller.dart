import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../data/services/bookmarkservice.dart';
import '../../core/algorithms/models/geo_point.dart';
import '../../core/algorithms/models/market_trends.dart';
import '../../core/algorithms/models/seasonal_data.dart';
import '../../core/algorithms/models/user_interaction_history.dart';
import '../../core/algorithms/models/user_preferences.dart';
import '../../core/algorithms/property_recommender.dart';
import '../../data/enums/enums.dart';
import '../../../core.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../data/services/db_helper.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math' as Math; // Import the math library

class HomeController extends GetxController {
  final properties = <RecordModel>[].obs;
  final featuredProperties = <RecordModel>[].obs;
  var isLoading = true.obs;
  int currentPage = 1;
  int totalListing = 20;
  var status = Status.initial.obs;
  final hasMoreData = true.obs;
  final totalItems = 0.obs;
  final isLoadingMore = false.obs;
  final hasError = false.obs;
  final searchQuery = ''.obs;
  final selectedFilter = RxString('');
  final filteredProperties = <RecordModel>[].obs;
  late final UserPreferences userPrefs;
  late final UserInteractionHistory interactions;
  late final MarketTrends trends;
  late final SeasonalData seasonal;
  final recommendedProperties = <RecordModel>[].obs;
  RxMap<String, double> pricePredictions = <String, double>{}.obs;
  Logger logger = Logger();
  final listController = ScrollController();
  final pb = PocketBase(DbHelper.getPocketbaseUrl());

  @override
  void onInit() {
    super.onInit();
    loadProperties();
    _initializeRecommendationSystem();
    loadRecommendations();
    loadFeaturedProperties();
    loadMore();
  }

  Future<void> loadFeaturedProperties() async {
    try {
      final response = await pb.collection('properties').getList(
            filter: 'featured = true',
            sort: '-created',
            perPage: 5,
          );
      featuredProperties.value = response.items;
    } catch (e) {
      logger.e('Error loading featured properties: $e');
    }
  }

  Stream<List<RecordModel>> getProperties(int page) async* {
    status(Status.loading);
    isLoading(true);
    hasError(false);
    try {
      final currentUser = pb.authStore.record;
      final userCountry = currentUser?.data['country'];
      final userState = currentUser?.data['state'];
      final userCity = currentUser?.data['city'];
      var filter = '';
       if (searchQuery.isNotEmpty) {
        filter =
            'title ~ "${searchQuery.value}" || location ~ "${searchQuery.value}"';
      }
      final response = await pb.collection('properties').getList(
            page: page,
            perPage: totalListing,
            filter: filter,
          );
      totalItems(response.totalItems);
      hasMoreData(properties.length < totalItems.value);
      final List<RecordModel> sortedItems = List.from(response.items);

       // Get user's geopoint from country, state, and city using geocoding
      GeoPoint? userLocation;
        if(userCountry != null && userState != null && userCity != null){
          userLocation = await _getGeoPointFromLocation(userCountry, userState, userCity);
        }
        
       if(userLocation != null){
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
       }else{
        sortedItems.sort((b, a) => b.get<String>('created').compareTo(a.get<String>('created')));
       }


      yield sortedItems;
      status(Status.success);
      isLoading(false);
      update();
    } catch (e) {
      status(Status.error);
      hasError(true);
      logger.e('Error fetching properties: $e');
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

  // Helper function to get GeoPoint from a property record
  GeoPoint? _getGeoPointFromProperty(RecordModel property) {
    final latitude = property.data['latitude'];
    final longitude = property.data['longitude'];

    if(latitude is double && longitude is double){
        return GeoPoint(latitude: latitude, longitude: longitude);
    } else{
      return null;
    }
  }

  Future<GeoPoint?> _getGeoPointFromLocation(String country, String state, String city) async {
    try{
        List<Location> locations = await locationFromAddress("$city, $state, $country");
        if (locations.isNotEmpty) {
            return GeoPoint(latitude: locations.first.latitude, longitude: locations.first.longitude);
        }
        return null;
      }catch(e){
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
    final bookmarkService = Get.find<BookmarkService>();
    await bookmarkService.loadBookmarks();
    getProperties(currentPage).listen((data) {
      properties(data);
       filterProperties(selectedFilter.value);
    });
  }

  void refreshAfterBookmarkChange() {
    loadProperties();
    update();
  }

  void retryLoading() {
    loadProperties();
    update();
  }

  void loadMore() {
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

  void _initializeRecommendationSystem() {
    userPrefs = UserPreferences(
      targetPrice: 250000.0,
      preferredLocation: GeoPoint(latitude: 0, longitude: 0),
      preferredAmenities: ['parking', 'pool'],
      preferredType: 'apartment',
    );
    interactions = UserInteractionHistory(
      viewCounts: {},
      favorites: {},
      clicks: {},
    );
    trends = MarketTrends();
    seasonal = SeasonalData();
  }

  Future<void> loadRecommendations() async {
    if (properties.isNotEmpty) {
      recommendedProperties.value = PropertyRecommender.getRecommendations(
        properties.toList(),
        userPrefs,
        interactions,
        trends,
        seasonal,
      );
    }
  }

  void filterProperties(String category) {
    selectedFilter.value = category;
    if (category.isEmpty) {
      filteredProperties.value = properties.toList();
      return;
    }
    filteredProperties.value = properties.where((property) {
      return property.data['category']?.toString().toLowerCase() ==
          category.toLowerCase();
    }).toList();
  }

  @override
  void onClose() {
    listController.dispose();
    super.onClose();
  }
}