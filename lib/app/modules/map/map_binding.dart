import 'package:get/get.dart';

import 'map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapController>(
      MapController.new,
    );
  }
}
