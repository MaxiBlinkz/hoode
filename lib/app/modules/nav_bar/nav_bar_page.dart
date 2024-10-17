import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/modules/map/map_page.dart';
import 'package:hoode/app/modules/profile/profile_page.dart';
import 'package:hoode/app/modules/settings/settings_page.dart';
import 'package:iconly/iconly.dart';

import '../home/home_page.dart';
import 'nav_bar_controller.dart';
 
class NavBarPage extends GetView<NavBarController> {
  const NavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: controller.tabIndex.value,
        children: const [
          HomePage(),
          ProfilePage(),
          MapPage(),
          SettingsPage(),
        ]
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          child: const Icon(IconlyBold.discovery),
          onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(IconlyBold.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(IconlyBold.discovery), label: "Explore"),
            BottomNavigationBarItem(icon: Icon(IconlyBold.profile), label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(IconlyBold.setting), label: "Settings"),
          ],
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.black,
          currentIndex: controller.tabIndex.value,
          onTap: (int index) {
            controller.changeTabIndex(index);
          }),
    );
  }
}
