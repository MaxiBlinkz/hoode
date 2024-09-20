import 'home_routes.dart';
import 'listing_detail_routes.dart';
import 'listing_search_routes.dart';
import 'dashboard_routes.dart';
import 'login_routes.dart';
import 'register_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/login';

  static final routes = [
    ...HomeRoutes.routes,
		...ListingDetailRoutes.routes,
		...ListingSearchRoutes.routes,
		...DashboardRoutes.routes,
		...LoginRoutes.routes,
		...RegisterRoutes.routes,
  ];
}
