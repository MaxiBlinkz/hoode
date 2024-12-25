import 'package:get/get.dart';
import 'package:hoode/app/data/services/authservice.dart';

import 'home_routes.dart';
import 'listing_detail_routes.dart';
import 'listing_search_routes.dart';
import 'login_routes.dart';
import 'register_routes.dart';
import 'profile_setup_routes.dart';
import 'nav_bar_routes.dart';
import 'settings_routes.dart';
import 'dashboard_routes.dart';
import 'splash_screen_routes.dart';
import 'onboarding_routes.dart';
import 'auth_routes.dart';
import 'map_view_routes.dart';
import 'add_listing_routes.dart';
import 'my_listings_routes.dart';
import 'edit_profile_routes.dart';
import 'bookmarks_routes.dart';

class AppPages {
  AppPages._();

  static String get INITIAL {
    final authService = Get.find<AuthService>();
    return authService.isAuthenticated.value ? '/nav-bar' : '/login';
  }

  static final routes = [
    ...HomeRoutes.routes,
    ...ListingDetailRoutes.routes,
    ...ListingSearchRoutes.routes,
    ...LoginRoutes.routes,
    ...RegisterRoutes.routes,
    ...ProfileSetupRoutes.routes,
    ...NavBarRoutes.routes,
    ...SettingsRoutes.routes,
    ...ProfileRoutes.routes,
		...SplashScreenRoutes.routes,
		...OnboardingRoutes.routes,
		...AuthRoutes.routes,
		...MapViewRoutes.routes,
		...AddListingRoutes.routes,
		...MyListingsRoutes.routes,
		...EditProfileRoutes.routes,
		...BookmarksRoutes.routes,
  ];
}
