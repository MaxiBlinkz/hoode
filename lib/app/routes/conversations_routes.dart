import 'package:get/get.dart';

import '../modules/conversations/conversations_binding.dart';
import '../modules/conversations/conversations_page.dart';

class ConversationsRoutes {
  ConversationsRoutes._();

  static const conversations = '/conversations';

  static final routes = [
    GetPage(
      name: conversations,
      page: ConversationsPage.new,
      binding: ConversationsBinding(),
    ),
  ];
}
