import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/enums/enums.dart';
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

  Logger logger = Logger();
  final listController = ScrollController();
  final pb = PocketBase(DbHelper.getPocketbaseUrl());

  @override
  void onInit() {
    super.onInit();
    loadProperties();
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
            properties.addAll(data); // This preserves existing items
          }
          isLoadingMore(false);
        }, onError: (error) {
          isLoadingMore(false);
          logger.e('Error loading more properties: $error');
        });
      }
    });
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
