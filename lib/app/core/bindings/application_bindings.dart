import 'package:get/get.dart';
import 'package:hoode/app/modules/home/home_controller.dart';
import 'package:hoode/app/modules/listing_detail/listing_detail_controller.dart';
import 'package:hoode/app/modules/profile_setup/profile_setup_controller.dart';
import 'package:hoode/app/modules/register/register_controller.dart';

class ApplicationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ListingDetailController(), fenix: true);
    Get.lazyPut(() => ProfileSetupController(), fenix: true);
    Get.lazyPut(() => RegisterController(), fenix: true);
  }
}
