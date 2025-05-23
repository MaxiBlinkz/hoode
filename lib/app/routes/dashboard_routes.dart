import 'package:get/get.dart';

import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_page.dart';

class ProfileRoutes {
  ProfileRoutes._();

  static const profile = '/profile';

  static final routes = [
    GetPage(
      name: profile,
      page: DashboardPage.new,
      binding: DashboardBinding()
    ),
  ];
}
