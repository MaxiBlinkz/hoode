import 'package:get/get.dart';
import 'package:hoode/app/data/services/adservice.dart';
import 'package:hoode/app/data/services/bookmarkservice.dart';
import 'package:hoode/app/modules/home/home_controller.dart';
import 'package:hoode/app/modules/listing_detail/listing_detail_controller.dart';
import 'package:hoode/app/modules/map_view/map_view_controller.dart';
import 'package:hoode/app/modules/profile_setup/profile_setup_controller.dart';
import 'package:hoode/app/modules/register/register_controller.dart';

class ApplicationBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AdService());
    Get.put(BookmarkService());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ListingDetailController(), fenix: true);
    Get.lazyPut(() => ProfileSetupController(), fenix: true);
    Get.lazyPut(() => RegisterController(), fenix: true);
    Get.lazyPut(() => MapViewController(), fenix: true);
  }
}
