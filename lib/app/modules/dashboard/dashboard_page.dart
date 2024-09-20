import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/modules/home/home_page.dart';

import 'dashboard_controller.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DashboardPage'),
        centerTitle: true,
      ),
      body: IndexedStack(
        children: [
          HomePage(),
        ],
      ),
    );
  }
}
