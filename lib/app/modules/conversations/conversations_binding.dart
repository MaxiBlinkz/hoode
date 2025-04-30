import 'package:get/get.dart';

import 'conversations_controller.dart';

class ConversationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationsController>(
      ConversationsController.new,
    );
  }
}
