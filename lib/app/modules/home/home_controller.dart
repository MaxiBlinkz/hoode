import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;


class HomeController extends GetxController {
  final properties = [].obs;
  var isLoading = true.obs;
  int currentPage = 1;
  int totalListing = 20;
  var status = Status.pending.obs;

  Logger logger = Logger();

  final listController = ScrollController();

  final pb = PocketBase(POCKETBASE_URL);
  // final pb = POCKETBASE;

  // Add this method to get current location
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  // Modified getProperties to sort by distance from current location
  Stream<List<RecordModel>> getProperties(int page) async* {
    status(Status.loading);
    isLoading(true);
    try {
      final response = await pb.collection('properties').getList(
            page: page,
            perPage: totalListing,
            sort: 'longitude,latitude', // Add sorting parameters
            // You can also use -longitude,-latitude for descending order
          );
    
      // Optional: Additional client-side sorting using coordinates
      final sortedItems = response.items
        ..sort((a, b) {
          final aLong = double.parse(a.data['longitude'].toString());
          final bLong = double.parse(b.data['longitude'].toString());
          return aLong.compareTo(bLong);
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

  // Modified getProperties to sort by distance from current location
  Stream<List<RecordModel>> getNearestProperties(int page) async* {
    status(Status.loading);
    isLoading(true);
    try {
      final currentLocation = await getCurrentLocation();
      final response = await pb.collection('properties').getList(
            page: page,
            perPage: totalListing,
          );

      // Sort by distance from current location
      final sortedItems = response.items
        ..sort((a, b) {
          final aDistance = Geolocator.distanceBetween(
              currentLocation.latitude,
              currentLocation.longitude,
              double.parse(a.data['latitude']),
              double.parse(a.data['longitude']));

          final bDistance = Geolocator.distanceBetween(
              currentLocation.latitude,
              currentLocation.longitude,
              double.parse(b.data['latitude']),
              double.parse(b.data['longitude']));

          return aDistance.compareTo(bDistance);
        });

      yield sortedItems;
    } catch (e) {
      // Error handling
      status(Status.error);
      logger.e('Error fetching properties: $e');
    }
  }
  Future<void> loadProperties() async {
    getProperties(currentPage).listen((data) {
      properties(data);
    });
  }

  Future<void> loadMore() async {
    listController.addListener(() async {
      if (listController.position.maxScrollExtent == listController.offset) {
        currentPage++;
        try {
          // final response = await pb.collection('properties').getList(
          //       page: currentPage,
          //       perPage: totalListing,
          //       // filter: 'created >= "2022-01-01 00:00:00" && someField1 != someField2',
          //     );
          getProperties(currentPage).listen((data) {
            properties.value.addAll(data);
          });
          //properties.addAll(response.items);
          update();
        } catch (e) {
          logger.e('Error loading more properties: $e');
        }
      }
    });
  }

  @override
  void onInit() async {
    super.onInit();
    getProperties(currentPage);
    loadProperties();
    loadMore();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    listController.dispose();
  }
}
