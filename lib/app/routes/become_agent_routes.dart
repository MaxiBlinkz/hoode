import 'package:get/get.dart';

import '../modules/become_agent/become_agent_binding.dart';
import '../modules/become_agent/become_agent_page.dart';

class BecomeAgentRoutes {
  BecomeAgentRoutes._();

  static const becomeAgent = '/become-agent';

  static final routes = [
    GetPage(
      name: becomeAgent,
      page: BecomeAgentPage.new,
      binding: BecomeAgentBinding(),
    ),
  ];
}
