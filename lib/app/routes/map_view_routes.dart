import 'package:get/get.dart';

import '../modules/map_view/map_view_binding.dart';
import '../modules/map_view/map_view_page.dart';

class MapViewRoutes {
  MapViewRoutes._();

  static const mapView = '/map-view';

  static final routes = [
    GetPage(
      name: mapView,
      page: MapViewPage.new,
      binding: MapViewBinding(),
    ),
  ];
}
