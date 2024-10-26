import 'package:get/get.dart';

import 'sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(
      SignInController.new,
    );
  }
}
