import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingsPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SettingsPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
