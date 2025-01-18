import 'package:get/get.dart';

import '../modules/nav_bar/nav_bar_binding.dart';
import '../modules/nav_bar/nav_bar_page.dart';

class NavBarRoutes {
  NavBarRoutes._();

  static const navBar = '/nav-bar';

  static final routes = [
    GetPage(
      name: navBar,
      page: NavBarPage.new,
      binding: NavBarBinding(),
    ),
  ];
}
