import 'package:get/get.dart';

import 'listing_detail_controller.dart';

class ListingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListingDetailController>(
      ListingDetailController.new,
    );
  }
}
