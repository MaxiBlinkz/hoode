import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:pocketbase/pocketbase.dart';

class HomeController extends GetxController {
  List<RecordModel> properties = [];
  var isLoading = true.obs;
  int currentPage = 1;
  int totalListing = 20;
  var status = Status.pending.obs;
  Rx<Object> err = "".obs;

  final listController = ScrollController();

  final pb = PocketBase(POCKETBASE_URL_ANDROID);
  // final pb = POCKETBASE;

  Future<void> getProperties() async {
    status(Status.loading);
    isLoading(true);
    try {
      final response = await pb.collection('properties').getList(
            page: currentPage,
            perPage: totalListing,
            // filter: 'created >= "2022-01-01 00:00:00" && someField1 != someField2',
          );
      properties.assignAll(response.items);
      update();
    } catch (e) {
      status(Status.error);
      err.value = e;
      print('Error fetching properties: $e');
    } finally {
      status(Status.success);
      isLoading(false);
    }
  }

  Future<void> loadMore() async {
    listController.addListener(() async {
      if (listController.position.maxScrollExtent == listController.offset) {
        currentPage++;
        try {
          final response = await pb.collection('properties').getList(
                page: currentPage,
                perPage: totalListing,
                // filter: 'created >= "2022-01-01 00:00:00" && someField1 != someField2',
              );
          properties.addAll(response.items);
          update();
        } catch (e) {
          print('Error fetching properties: $e');
        }
      }
    });
  }

  @override
  void onInit() async {
    super.onInit();
    getProperties();
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
