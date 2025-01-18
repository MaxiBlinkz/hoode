import 'package:get/get.dart';

import '../modules/user_preference/user_preference_binding.dart';
import '../modules/user_preference/user_preference_page.dart';

class UserPreferenceRoutes {
  UserPreferenceRoutes._();

  static const userPreference = '/user-preference';

  static final routes = [
    GetPage(
      name: userPreference,
      page: UserPreferencePage.new,
      binding: UserPreferenceBinding(),
    ),
  ];
}
