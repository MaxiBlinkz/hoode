import 'package:get/get.dart';

import '../modules/messages/conversations_binding.dart';
import '../modules/messages/conversations_page.dart';

class MessagesRoutes {
  MessagesRoutes._();

  static const conversations = '/conversations';

  static final routes = [
    GetPage(
      name: conversations,
      page: ConversationsPage.new,
      binding: ConversationsBinding(),
    ),
  ];
}
