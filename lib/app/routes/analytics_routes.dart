import 'package:get/get.dart';

import '../modules/analytics/analytics_binding.dart';
import '../modules/analytics/analytics_page.dart';

class AnalyticsRoutes {
  AnalyticsRoutes._();

  static const analytics = '/analytics';

  static final routes = [
    GetPage(
      name: analytics,
      page: AnalyticsPage.new,
      binding: AnalyticsBinding(),
    ),
  ];
}
