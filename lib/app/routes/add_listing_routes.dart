import 'package:get/get.dart';

import '../modules/add_listing/add_listing_binding.dart';
import '../modules/add_listing/add_listing_page.dart';

class AddListingRoutes {
  AddListingRoutes._();

  static const addListing = '/add-listing';

  static final routes = [
    GetPage(
      name: addListing,
      page: AddListingPage.new,
      binding: AddListingBinding(),
    ),
  ];
}
