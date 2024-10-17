import 'package:get/get.dart';

import '../modules/profile_setup/profile_setup_binding.dart';
import '../modules/profile_setup/profile_setup_page.dart';

class ProfileSetupRoutes {
  ProfileSetupRoutes._();

  static const profileSetup = '/profile-setup';

  static final routes = [
    GetPage(
      name: profileSetup,
      page: ProfileSetupPage.new,
      binding: ProfileSetupBinding(),
    ),
  ];
}
