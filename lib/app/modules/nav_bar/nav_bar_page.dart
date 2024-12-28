import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/modules/bookmarks/bookmarks_page.dart';
import 'package:hoode/app/modules/dashboard/dashboard_page.dart';
import 'package:hoode/app/modules/settings/settings_page.dart';
import 'package:iconly/iconly.dart';

import '../home/home_page.dart';
import 'nav_bar_controller.dart';

class NavBarPage extends StatelessWidget {
  const NavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () => controller.gotoMapView(),
          //   backgroundColor: AppColors.primary,
          //   foregroundColor: Colors.white,
          //   child: const Icon(IconlyLight.location),
          // ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: NavigationBar(
                  selectedIndex: controller.tabIndex,
                  onDestinationSelected: controller.changeTabIndex,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(IconlyLight.home),
                      selectedIcon: Icon(IconlyBold.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(IconlyLight.category),
                      selectedIcon: Icon(IconlyBold.category),
                      label: 'Dashboard',
                    ),
                    NavigationDestination(
                      icon: Icon(IconlyLight.bookmark),
                      selectedIcon: Icon(IconlyBold.bookmark),
                      label: 'Bookmarks',
                    ),
                    NavigationDestination(
                      icon: Icon(IconlyLight.setting),
                      selectedIcon: Icon(IconlyBold.setting),
                      label: 'Settings',
                    ),
                  ],
                ),
              ),
            ),
          ),

        );
      },
    );
  }
}
