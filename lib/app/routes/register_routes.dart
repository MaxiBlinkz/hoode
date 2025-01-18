import 'package:get/get.dart';

import '../modules/register/register_binding.dart';
import '../modules/register/register_page.dart';

class RegisterRoutes {
  RegisterRoutes._();

  static const register = '/register';

  static final routes = [
    GetPage(
      name: register,
      page: RegisterPage.new,
      binding: RegisterBinding(),
    ),
  ];
}
