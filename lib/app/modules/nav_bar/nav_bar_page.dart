import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bookmarks/bookmarks_page.dart';
import '../dashboard/dashboard_page.dart';
import '../settings/settings_page.dart';
import 'package:iconly/iconly.dart';
import '../home/home_page.dart';
import 'nav_bar_controller.dart';

class NavBarPage extends GetView<NavBarController> {
  const NavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: [
          HomePage(),
          DashboardPage(),
          BookmarksPage(),
          SettingsPage(),
        ],
      )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Obx(() => NavigationBar(
          height: 80,
          selectedIndex: controller.tabIndex.value,
          onDestinationSelected: controller.changeTabIndex,
          backgroundColor: Theme.of(context).colorScheme.surface,
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            _buildNavDestination(IconlyLight.home, IconlyBold.home, 'Home'),
            _buildNavDestination(IconlyLight.category, IconlyBold.category, 'Dashboard'),
            _buildNavDestination(IconlyLight.bookmark, IconlyBold.bookmark, 'Bookmarks'),
            _buildNavDestination(IconlyLight.setting, IconlyBold.setting, 'Settings'),
          ],
        )),
      ),
    );
  }

  NavigationDestination _buildNavDestination(
      IconData icon, IconData selectedIcon, String label) {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: Icon(selectedIcon),
      label: label,
    );
  }
}
