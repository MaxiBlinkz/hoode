import 'package:get/get.dart';

import '../modules/sign_in/sign_in_binding.dart';
import '../modules/sign_in/sign_in_page.dart';

class SignInRoutes {
  SignInRoutes._();

  static const signIn = '/sign-in';

  static final routes = [
    GetPage(
      name: signIn,
      page: SignInPage.new,
      binding: SignInBinding(),
    ),
  ];
}
