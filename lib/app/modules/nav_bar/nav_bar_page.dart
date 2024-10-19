import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/modules/map/map_page.dart';
import 'package:hoode/app/modules/profile/profile_page.dart';
import 'package:hoode/app/modules/settings/settings_page.dart';
import 'package:iconly/iconly.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../home/home_page.dart';
import 'nav_bar_controller.dart';

class NavBarPage extends GetView<NavBarController> {
  const NavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: controller.tabIndex.value, children: const [
        HomePage(),
        ProfilePage(),
        MapPage(),
        SettingsPage(),
      ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          child: const Icon(IconlyBold.discovery),
          onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: StylishBottomBar(
        option: DotBarOptions(
          dotStyle: DotStyle.tile,
        ),
        items: [
          BottomBarItem(icon: const Icon(IconlyBold.home), title: const Text("Home")),
            BottomBarItem(
                icon: const Icon(IconlyBold.discovery), title: const Text("Explore")),
            BottomBarItem(
                icon: const Icon(IconlyBold.profile), title: const Text("Profile")),
            BottomBarItem(
                icon: const Icon(IconlyBold.setting), title: const Text("Settings")),
        ],
        onTap: (value) => controller.changeTabIndex(value),
      ),
    );
  }
}
