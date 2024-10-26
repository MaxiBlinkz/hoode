import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'onboarding_controller.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OnboardingPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OnboardingPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
