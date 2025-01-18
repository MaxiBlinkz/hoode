import 'package:get/get.dart';

import '../modules/chat_view/chat_view_binding.dart';
import '../modules/chat_view/chat_view_page.dart';

class ChatViewRoutes {
  ChatViewRoutes._();

  static const chatView = '/chat-view';

  static final routes = [
    GetPage(
      name: chatView,
      page: ChatViewPage.new,
      binding: ChatViewBinding(),
    ),
  ];
}
