import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;
  final storage = GetStorage();
  final pageController = PageController();
  
  final List<OnboardingItem> pages = [
    OnboardingItem(
      title: "Find Your Dream Home",
      description: "Discover beautiful properties in your preferred location",
      animation: "assets/animations/house_search.json",
    ),
    OnboardingItem(
      title: "Easy Property Search",
      description: "Filter by location, price and property features",
      animation: "assets/animations/property_filter.json",
    ),
    OnboardingItem(
      title: "Connect with Agents",
      description: "Direct messaging with verified property agents",
      animation: "assets/animations/chat_agent.json",
    ),
  ];

  void nextPage() {
    if (currentPage.value == pages.length - 1) {
      completeOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void completeOnboarding() {
    storage.write('has_seen_onboarding', true);
    Get.offAllNamed('/home');
  }

  void skip() {
    completeOnboarding();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}


class OnboardingItem {
  final String title;
  final String description;
  final String animation;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.animation,
  });
}
