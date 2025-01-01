import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/theme_controller.dart';
import '../bookmarks/bookmarks_page.dart';
import '../dashboard/dashboard_page.dart';
import '../settings/settings_page.dart';
import 'package:iconly/iconly.dart';
import '../home/home_page.dart';
import 'nav_bar_controller.dart';

class NavBarPage extends StatelessWidget {
  const NavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return GetBuilder<NavBarController>(
      init: NavBarController(),
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: controller.tabIndex,
            children: [
              HomePage(),
              DashboardPage(),
              BookmarksPage(),
              SettingsPage(),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              final scheme = themeController.currentScheme.value;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .shadowColor
                          .withValues(red: 0, green: 0, blue: 0, alpha: 0.2),
                      blurRadius: 5,
                      offset: const Offset(3, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: NavigationBar(
                    selectedIndex: controller.tabIndex,
                    onDestinationSelected: controller.changeTabIndex,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    indicatorColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    elevation: 0,
                    labelBehavior:
                        NavigationDestinationLabelBehavior.alwaysShow,
                    destinations: [
                      _buildNavDestination(
                          IconlyLight.home, IconlyBold.home, 'Home'),
                      _buildNavDestination(IconlyLight.category,
                          IconlyBold.category, 'Dashboard'),
                      _buildNavDestination(IconlyLight.bookmark,
                          IconlyBold.bookmark, 'Bookmarks'),
                      _buildNavDestination(
                          IconlyLight.setting, IconlyBold.setting, 'Settings'),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
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
