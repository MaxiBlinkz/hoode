import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash_screen_controller.dart';

class SplashScreenPage extends GetView<SplashScreenController> {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashScreenPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SplashScreenPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
