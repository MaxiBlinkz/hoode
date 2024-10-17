import 'package:get/get.dart';

import '../modules/settings/settings_binding.dart';
import '../modules/settings/settings_page.dart';

class SettingsRoutes {
  SettingsRoutes._();

  static const settings = '/settings';

  static final routes = [
    GetPage(
      name: settings,
      page: SettingsPage.new,
      binding: SettingsBinding(),
    ),
  ];
}
