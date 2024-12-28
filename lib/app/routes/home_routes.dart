import 'package:get/get.dart';
import 'package:hoode/app/core/middleware/auth_middleware.dart';
import 'package:hoode/app/core/middleware/onboarding_middleware.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_page.dart';

class HomeRoutes {
  HomeRoutes._();

  static const home = '/home';

  static final routes = [
    GetPage(
      name: home,
      page: HomePage.new,
      binding: HomeBinding(),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()]
    ),
  ];
}
