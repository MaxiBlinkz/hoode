import 'package:get/get.dart';
import '../theme/theme_controller.dart';
import '../../data/services/adservice.dart';
import '../../data/services/bookmarkservice.dart';
import '../../data/services/user_service.dart';
import '../../modules/add_listing/add_listing_controller.dart';
import '../../modules/become_agent/become_agent_controller.dart';
import '../../modules/bookmarks/bookmarks_controller.dart';
import '../../modules/edit_profile/edit_profile_controller.dart';
import '../../modules/home/home_controller.dart';
import '../../modules/listing_detail/listing_detail_controller.dart';
import '../../modules/listing_search/listing_search_controller.dart';
import '../../modules/map_view/map_view_controller.dart';
import '../../modules/dashboard/dashboard_controller.dart';
import '../../modules/profile_setup/profile_setup_controller.dart';
import '../../modules/register/register_controller.dart';
import '../../modules/settings/settings_controller.dart';
import '../../modules/user_preference/user_preference_controller.dart';

class ApplicationBindings extends Bindings {
  @override
  void dependencies() {
    // Services - Permanent instances
    Get.put(AdService(), permanent: true);
    Get.put(BookmarkService(), permanent: true);
    Get.put(UserService(), permanent: true);

    // Core features - Permanent controllers
    Get.put(ThemeController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => BookmarksController(), fenix: true);

    // Feature controllers - Created on demand
    Get.create(() => ListingDetailController());
    Get.create(() => ProfileSetupController());
    Get.create(() => RegisterController());
    Get.create(() => MapViewController());
    Get.create(() => ListingSearchController());
    Get.create(() => SettingsController());
    Get.create(() => BecomeAgentController());
    Get.create(() => EditProfileController());
    Get.create(() => AddListingController());
    Get.lazyPut(() => UserPreferenceController());
  }
}
