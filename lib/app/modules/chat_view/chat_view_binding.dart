import 'package:get/get.dart';

import 'chat_view_controller.dart';

class ChatViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatViewController>(
      ChatViewController.new,
    );
  }
}
