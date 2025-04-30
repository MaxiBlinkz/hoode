import 'package:get/get.dart';

import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_page.dart';

class OnboardingRoutes {
  OnboardingRoutes._();

  static const onboarding = '/onboarding';

  static final routes = [
    GetPage(
      name: onboarding,
      page: OnboardingPage.new,
      binding: OnboardingBinding(),
    ),
  ];
}
