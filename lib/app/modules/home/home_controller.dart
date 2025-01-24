import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/services/bookmarkservice.dart';
import '../../core/algorithms/models/geo_point.dart';
import '../../core/algorithms/models/market_trends.dart';
import '../../core/algorithms/models/seasonal_data.dart';
import '../../core/algorithms/models/user_interaction_history.dart';
import '../../core/algorithms/models/user_preferences.dart';
import '../../core/algorithms/property_recommender.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/core.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/data/services/db_helper.dart';

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

      final sortedItems = response.items;
      sortedItems.sort((a, b) {
        final aCountryMatch = a.data['country'] == userCountry;
        final bCountryMatch = b.data['country'] == userCountry;
        if (aCountryMatch != bCountryMatch) return aCountryMatch ? -1 : 1;

        if (aCountryMatch && bCountryMatch) {
          final aStateMatch = a.data['state'] == userState;
          final bStateMatch = b.data['state'] == userState;
          if (aStateMatch != bStateMatch) return aStateMatch ? -1 : 1;

          if (aStateMatch && bStateMatch) {
            final aCityMatch = a.data['city'] == userCity;
            final bCityMatch = b.data['city'] == userCity;
            if (aCityMatch != bCityMatch) return aCityMatch ? -1 : 1;
          }
        }
        return b.get<String>('created').compareTo(a.get<String>('created'));
      });

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
