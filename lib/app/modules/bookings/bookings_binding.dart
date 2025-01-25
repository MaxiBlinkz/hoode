import 'package:get/get.dart';

import 'bookings_controller.dart';

class BookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingsController>(
      BookingsController.new,
    );
  }
}
