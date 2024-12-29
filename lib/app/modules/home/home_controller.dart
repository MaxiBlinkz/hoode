import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../core/algorithms/models/geo_point.dart';
import '../../core/algorithms/models/market_trends.dart';
import '../../core/algorithms/models/seasonal_data.dart';
import '../../core/algorithms/models/user_interaction_history.dart';
import '../../core/algorithms/models/user_preferences.dart';
import '../../core/algorithms/property_recommender.dart';
// import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/data/repositories/mock_property_database.dart';
import 'package:hoode/core.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/data/services/db_helper.dart';

class HomeController extends GetxController {
  final properties = [].obs;
  var isLoading = true.obs;
  int currentPage = 1;
  int totalListing = 20;
  var status = Status.initial.obs;
  final hasMoreData = true.obs;
  final totalItems = 0.obs;
  final isLoadingMore = false.obs;

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
    // testWithMockData();
    loadMore();
  }

  Stream<List<RecordModel>> getProperties(int page) async* {
    status(Status.loading);
    isLoading(true);
    try {
      final currentUser = pb.authStore.record;
      final userCountry = currentUser?.data['country'];
      final userState = currentUser?.data['state'];
      final userCity = currentUser?.data['city'];

      final response = await pb.collection('properties').getList(
            page: page,
            perPage: totalListing,
          );
  
      totalItems(response.totalItems);
      hasMoreData(properties.length < totalItems.value);

      final sortedItems = response.items;

      // Enhanced location-based sorting
      sortedItems.sort((a, b) {
        // Country match comparison
        final aCountryMatch = a.data['country'] == userCountry;
        final bCountryMatch = b.data['country'] == userCountry;
        if (aCountryMatch != bCountryMatch) {
          return aCountryMatch ? -1 : 1;
        }

        // If same country match status, check state
        if (aCountryMatch && bCountryMatch) {
          final aStateMatch = a.data['state'] == userState;
          final bStateMatch = b.data['state'] == userState;
          if (aStateMatch != bStateMatch) {
            return aStateMatch ? -1 : 1;
          }

          // If same state match status, check city
          if (aStateMatch && bStateMatch) {
            final aCityMatch = a.data['city'] == userCity;
            final bCityMatch = b.data['city'] == userCity;
            if (aCityMatch != bCityMatch) {
              return aCityMatch ? -1 : 1;
            }
          }
        }

        // If all location matches are equal, sort by created date
        return b.get<String>('created').compareTo(a.get<String>('created'));
      });

      yield sortedItems;

      if (sortedItems.isNotEmpty) {
        status(Status.success);
        isLoading(false);
      }
      update();

    } catch (e) {
      status(Status.error);
      logger.e('Error fetching properties: $e');
    }
  }


  Future<void> loadProperties() async {
    getProperties(currentPage).listen((data) {
      properties(data);
    });
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
        getProperties(currentPage).listen((data) {
          if (data.isEmpty) {
            hasMoreData(false);
          } else {
            // Preserve existing items and add new ones
            properties.addAll(data);
          }
          isLoadingMore(false);
        }, onError: (error) {
          isLoadingMore(false);
          logger.e('Error loading more properties: $error');
        });
      }
    });
  }


  void _initializeRecommendationSystem() {
    // Initialize with user data from your auth system
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
        properties.cast<RecordModel>().toList(),
        userPrefs,
        interactions,
        trends,
        seasonal,
      );
    }
  }

  // Add this method
  void testWithMockData() {
    // Load mock properties
    properties.value = MockPropertyDatabase.getMockProperties();
    _initializeRecommendationSystem();
    loadRecommendations();

    // Log results for verification
    logger.d('Total properties loaded: ${properties.length}');
    logger.d('Recommended properties: ${recommendedProperties.length}');

    // Test property sorting and filtering
    final sortedByPrice =
        properties.where((p) => p.data['price'] < 300000).toList();
    logger.d('Properties under 300k: ${sortedByPrice.length}');
  }



  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    listController.dispose();
    super.onClose();
  }
}
