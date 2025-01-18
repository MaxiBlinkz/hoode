import 'package:get/get.dart';

import '../modules/change_password/change_password_binding.dart';
import '../modules/change_password/change_password_page.dart';

class ChangePasswordRoutes {
  ChangePasswordRoutes._();

  static const changePassword = '/change-password';

  static final routes = [
    GetPage(
      name: changePassword,
      page: ChangePasswordPage.new,
      binding: ChangePasswordBinding(),
    ),
  ];
}
