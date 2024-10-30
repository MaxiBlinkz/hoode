import 'home_routes.dart';
import 'listing_detail_routes.dart';
import 'listing_search_routes.dart';
import 'login_routes.dart';
import 'register_routes.dart';
import 'profile_setup_routes.dart';
import 'nav_bar_routes.dart';
import 'settings_routes.dart';
import 'map_routes.dart';
import 'profile_routes.dart';
import 'sign_in_routes.dart';
import 'splash_screen_routes.dart';
import 'onboarding_routes.dart';
import 'auth_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/nav-bar';

  static final routes = [
    ...HomeRoutes.routes,
    ...ListingDetailRoutes.routes,
    ...ListingSearchRoutes.routes,
    ...LoginRoutes.routes,
    ...RegisterRoutes.routes,
    ...ProfileSetupRoutes.routes,
    ...NavBarRoutes.routes,
    ...SettingsRoutes.routes,
    ...MapRoutes.routes,
    ...ProfileRoutes.routes,
		...SignInRoutes.routes,
		...SplashScreenRoutes.routes,
		...OnboardingRoutes.routes,
		...AuthRoutes.routes,
  ];
}
