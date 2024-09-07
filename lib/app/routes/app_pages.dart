import 'home_routes.dart';
import 'listing_detail_routes.dart';
import 'listing_search_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/home';

  static final routes = [
    ...HomeRoutes.routes,
		...ListingDetailRoutes.routes,
		...ListingSearchRoutes.routes,
  ];
}
