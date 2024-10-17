import 'package:get/get.dart';

import 'nav_bar_controller.dart';

class NavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavBarController>(
      NavBarController.new,
    );
  }
}
