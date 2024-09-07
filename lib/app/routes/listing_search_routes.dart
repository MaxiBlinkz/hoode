import 'package:get/get.dart';

import '../modules/listing_search/listing_search_binding.dart';
import '../modules/listing_search/listing_search_page.dart';

class ListingSearchRoutes {
  ListingSearchRoutes._();

  static const listingSearch = '/listing-search';

  static final routes = [
    GetPage(
      name: listingSearch,
      page: ListingSearchPage.new,
      binding: ListingSearchBinding(),
    ),
  ];
}
