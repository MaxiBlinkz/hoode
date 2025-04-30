
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
import 'conversations_routes.dart';
import 'chat_view_routes.dart';
import 'become_agent_routes.dart';
import 'user_preference_routes.dart';
import 'change_password_routes.dart';
import 'bookings_routes.dart';
import 'analytics_routes.dart';

class AppPages {
  AppPages._();


  static String get INITIAL => '/splash-screen';

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
		...ConversationsRoutes.routes,
		...ChatViewRoutes.routes,
		...BecomeAgentRoutes.routes,
		...UserPreferenceRoutes.routes,
		...ChangePasswordRoutes.routes,
    ...AnalyticsRoutes.routes,
		...BookingsRoutes.routes,
  ];
}
