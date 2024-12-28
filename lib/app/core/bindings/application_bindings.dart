import 'package:get/get.dart';
import 'package:hoode/app/data/services/adservice.dart';
import 'package:hoode/app/data/services/bookmarkservice.dart';
import 'package:hoode/app/data/services/user_service.dart';
import 'package:hoode/app/modules/add_listing/add_listing_controller.dart';
import 'package:hoode/app/modules/become_agent/become_agent_controller.dart';
import 'package:hoode/app/modules/bookmarks/bookmarks_controller.dart';
import 'package:hoode/app/modules/edit_profile/edit_profile_controller.dart';
import 'package:hoode/app/modules/home/home_controller.dart';
import 'package:hoode/app/modules/listing_detail/listing_detail_controller.dart';
import 'package:hoode/app/modules/listing_search/listing_search_controller.dart';
import 'package:hoode/app/modules/map_view/map_view_controller.dart';
import 'package:hoode/app/modules/dashboard/dashboard_controller.dart';
import 'package:hoode/app/modules/profile_setup/profile_setup_controller.dart';
import 'package:hoode/app/modules/register/register_controller.dart';
import 'package:hoode/app/modules/settings/settings_controller.dart';

class ApplicationBindings extends Bindings {
  @override
  void dependencies() {
    // Services - Permanent instances
    Get.put(AdService(), permanent: true);
    Get.put(BookmarkService(), permanent: true);
    Get.put(UserService(), permanent: true);

    // Core features - Permanent controllers
    Get.put(HomeController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.lazyPut(()=> DashboardController(), fenix: true);
    Get.lazyPut(()=> BookmarksController(), fenix: true);

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
  }
}
