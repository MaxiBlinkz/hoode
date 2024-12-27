import 'package:get/get.dart';

import '../modules/messages/messages_binding.dart';
import '../modules/messages/messages_page.dart';

class MessagesRoutes {
  MessagesRoutes._();

  static const messages = '/messages';

  static final routes = [
    GetPage(
      name: messages,
      page: MessagesPage.new,
      binding: MessagesBinding(),
    ),
  ];
}
