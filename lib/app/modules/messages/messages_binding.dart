import 'package:get/get.dart';

import 'messages_controller.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagesController>(
      MessagesController.new,
    );
  }
}
