import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/modules/map_view/map_view_page.dart';
import 'package:hoode/app/modules/profile/profile_page.dart';
import 'package:hoode/app/modules/settings/settings_page.dart';
import 'package:iconly/iconly.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

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
            children: const [
              HomePage(),
              ProfilePage(),
              MapViewPage(),
              SettingsPage(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            child: const Icon(IconlyBold.discovery),
            onPressed: () {
              Get.to(const MapViewPage());
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: StylishBottomBar(
            currentIndex: controller.tabIndex,
            option: DotBarOptions(
              dotStyle: DotStyle.tile,
            ),
            items: [
              BottomBarItem(
                  icon: const Icon(IconlyLight.home),
                  title: const Text("Home")),
              BottomBarItem(
                  icon: const Icon(IconlyLight.discovery),
                  title: const Text("Explore")),
              BottomBarItem(
                  icon: const Icon(IconlyLight.profile),
                  title: const Text("Profile")),
              BottomBarItem(
                  icon: const Icon(IconlyLight.setting),
                  title: const Text("Settings")),
            ],
            onTap: (value) => controller.changeTabIndex(value),
          ),
        );
      },
    );
  }
}
