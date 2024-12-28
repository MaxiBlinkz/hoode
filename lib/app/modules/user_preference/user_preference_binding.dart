import 'package:get/get.dart';

import 'user_preference_controller.dart';

class UserPreferenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPreferenceController>(
      UserPreferenceController.new,
    );
  }
}
