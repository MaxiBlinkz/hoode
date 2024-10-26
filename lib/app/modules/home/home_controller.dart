import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart' as bugnag;

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

  Stream<List<RecordModel>> getProperties(int page) async* {
    status(Status.loading);
    isLoading(true);
    try {
      final response = await pb.collection('properties').getList(
            page: page,
            perPage: totalListing,
            // filter: 'created >= "2022-01-01 00:00:00" && someField1 != someField2',
          );
      yield response.items;

      //properties.assignAll(response.items);
      if (response.items.isNotEmpty) {
        status(Status.success);
        isLoading(false);
      }
      update();
    } catch (e, stack) {
      status(Status.error);
      logger.e('Error fetching properties: $e');
      await bugnag.bugsnag.notify(e, stack);
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
