import 'package:get/get.dart';

import '../modules/auth/auth_binding.dart';
import '../modules/auth/auth_page.dart';

class AuthRoutes {
  AuthRoutes._();

  static const auth = '/auth';

  static final routes = [
    GetPage(
      name: auth,
      page: AuthPage.new,
      binding: AuthBinding(),
    ),
  ];
}
