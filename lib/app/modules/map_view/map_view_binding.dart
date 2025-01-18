import 'package:get/get.dart';

import 'map_view_controller.dart';

class MapViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapViewController>(
      MapViewController.new,
    );
  }
}
