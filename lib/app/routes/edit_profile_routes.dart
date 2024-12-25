import 'package:get/get.dart';

import '../modules/edit_profile/edit_profile_binding.dart';
import '../modules/edit_profile/edit_profile_page.dart';

class EditProfileRoutes {
  EditProfileRoutes._();

  static const editProfile = '/edit-profile';

  static final routes = [
    GetPage(
      name: editProfile,
      page: EditProfilePage.new,
      binding: EditProfileBinding(),
    ),
  ];
}
