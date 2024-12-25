import 'package:get/get.dart';

import 'my_listings_controller.dart';

class MyListingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyListingsController>(
      MyListingsController.new,
    );
  }
}
