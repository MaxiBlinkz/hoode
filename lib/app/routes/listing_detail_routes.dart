import 'package:get/get.dart';

import '../modules/listing_detail/listing_detail_binding.dart';
import '../modules/listing_detail/listing_detail_page.dart';

class ListingDetailRoutes {
  ListingDetailRoutes._();

  static const listingDetail = '/listing-detail';

  static final routes = [
    GetPage(
      name: listingDetail,
      page: ListingDetailPage.new,
      binding: ListingDetailBinding(),
    ),
  ];
}
