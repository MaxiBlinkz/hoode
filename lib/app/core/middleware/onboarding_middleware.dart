import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final storage = GetStorage();
    final hasSeenOnboarding = storage.read('has_seen_onboarding') ?? false;

    if (!hasSeenOnboarding && route != '/onboarding') {
      return const RouteSettings(name: '/onboarding');
    }
    
    if (hasSeenOnboarding && route == '/onboarding') {
      return const RouteSettings(name: '/nav-bar');
    }

    return null;
  }
}
