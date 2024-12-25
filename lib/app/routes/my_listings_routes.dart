import 'package:get/get.dart';

import '../modules/my_listings/my_listings_binding.dart';
import '../modules/my_listings/my_listings_page.dart';

class MyListingsRoutes {
  MyListingsRoutes._();

  static const myListings = '/my-listings';

  static final routes = [
    GetPage(
      name: myListings,
      page: MyListingsPage.new,
      binding: MyListingsBinding(),
    ),
  ];
}
