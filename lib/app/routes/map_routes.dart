import 'package:get/get.dart';

import '../modules/map/map_binding.dart';
import '../modules/map/map_page.dart';

class MapRoutes {
  MapRoutes._();

  static const map = '/map';

  static final routes = [
    GetPage(
      name: map,
      page: MapPage.new,
      binding: MapBinding(),
    ),
  ];
}
