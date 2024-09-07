import 'package:get/get.dart';

import 'listing_search_controller.dart';

class ListingSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListingSearchController>(
      ListingSearchController.new,
    );
  }
}
