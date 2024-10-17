import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfilePage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfilePage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
