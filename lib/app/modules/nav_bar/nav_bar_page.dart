import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/modules/bookmarks/bookmarks_page.dart';
import 'package:hoode/app/modules/map_view/map_view_page.dart';
import 'package:hoode/app/modules/dashboard/dashboard_page.dart';
import 'package:hoode/app/modules/settings/settings_page.dart';
import 'package:iconly/iconly.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';

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
            extendBody: true,
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
              padding: const EdgeInsets.only(bottom: 10),
              child: CrystalNavigationBar(
                currentIndex: controller.tabIndex,
                unselectedItemColor: Colors.white70,
                backgroundColor: Colors.black.withOpacity(0.1),
                // outlineBorderColor: Colors.black.withOpacity(0.1),
                onTap: (value) => controller.changeTabIndex(value),
                items: [
                  /// Home
                  CrystalNavigationBarItem(
                    icon: IconlyBold.home,
                    unselectedIcon: IconlyLight.home,
                    selectedColor: Colors.white,
                  ),

                  /// Dashboard
                  CrystalNavigationBarItem(
                    icon: IconlyBold.category,
                    unselectedIcon: IconlyLight.category,
                    selectedColor: Colors.red,
                  ),

                  /// Bookmarks
                  CrystalNavigationBarItem(
                    icon: IconlyBold.bookmark,
                    unselectedIcon: IconlyLight.bookmark,
                    selectedColor: Colors.white,
                  ),

                  /// Settings
                  CrystalNavigationBarItem(
                      icon: IconlyBold.setting,
                      unselectedIcon: IconlyLight.setting,
                      selectedColor: Colors.white),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                controller.gotoMapView();
              },
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              child: Icon(IconlyLight.location),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,

            // floatingActionButton: FloatingActionButton(
            //   backgroundColor: AppColors.primary,
            //   foregroundColor: Colors.white,
            //   elevation: 0,
            //   child: const Icon(IconlyBold.discovery),
            //   onPressed: () {
            //     Get.to(const MapViewPage());
            //   },
            // ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerFloat,
            // bottomNavigationBar: StylishBottomBar(
            //   currentIndex: controller.tabIndex,
            //   option: DotBarOptions(
            //     dotStyle: DotStyle.tile,
            //   ),
            //   items: [
            //     BottomBarItem(
            //         icon: const Icon(IconlyLight.home),
            //         title: const Text("Home")),
            //     BottomBarItem(
            //         icon: const Icon(IconlyLight.discovery),
            //         title: const Text("Explore")),
            //     BottomBarItem(
            //         icon: const Icon(IconlyLight.profile),
            //         title: const Text("Profile")),
            //     BottomBarItem(
            //         icon: const Icon(IconlyLight.setting),
            //         title: const Text("Settings")),
            //   ],
            //   onTap: (value) => controller.changeTabIndex(value),
            // ),

            // bottomNavigationBar: FloatingBottomBar(
            //   currentIndex: controller.tabIndex,
            //   onTap: (value) => controller.changeTabIndex(value),
            //   leftItems: const [
            //      NavItemData(
            //     icon: IconlyLight.home,
            //       label: "Home"),
            //       NavItemData(
            //     icon: IconlyLight.category, label: "Dashboard"),
            //   ],
            //   rightItems: const [
            //      NavItemData(
            //     icon: IconlyLight.bookmark, label: "Bookmarks"),
            //       NavItemData(
            //     icon: IconlyLight.setting, label: "Settings"),
            //   ],
            //   floatingAction: const FloatingActionData(icon: IconlyLight.discovery),
            // )
          );
        });
  }
}
