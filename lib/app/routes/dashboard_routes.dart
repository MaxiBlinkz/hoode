import 'package:get/get.dart';

import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_page.dart';

class DashboardRoutes {
  DashboardRoutes._();

  static const dashboard = '/dashboard';

  static final routes = [
    GetPage(
      name: dashboard,
      page: DashboardPage.new,
      binding: DashboardBinding(),
    ),
  ];
}
