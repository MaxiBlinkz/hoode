import 'package:get/get.dart';

import 'add_listing_controller.dart';

class AddListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddListingController>(AddListingController());  // Use Get.put instead of lazyPut
  }
}
