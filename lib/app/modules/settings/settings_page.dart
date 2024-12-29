import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../../core/theme/colors.dart';
import '../user_preference/user_preference_page.dart';
import 'settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(IconlyLight.arrowLeft2),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        children: [
          _buildSection(
            'Appearance',
            [
              Obx(() => SwitchListTile(
                    title: const Text('Dark Mode'),
                    secondary: const Icon(IconlyLight.show),
                    value: controller.isDarkMode.value,
                    onChanged: controller.toggleTheme,
                  )),
            ],
          ),
          _buildSection(
            'Preferences',
            [
              ListTile(
                leading: const Icon(IconlyLight.message),
                title: const Text('Language'),
                trailing: Obx(() => Text(controller.selectedLanguage.value)),
                onTap: () => _showLanguageDialog(context),
              ),
              ListTile(
                leading: const Icon(IconlyLight.wallet),
                title: const Text('Currency'),
                trailing: Obx(() => Text(controller.selectedCurrency.value)),
                onTap: () => _showCurrencyDialog(context),
              ),
              Obx(() => SwitchListTile(
                    title: const Text('Notifications'),
                    secondary: const Icon(IconlyLight.notification),
                    value: controller.isNotificationsEnabled.value,
                    onChanged: controller.toggleNotifications,
                  )),
              ListTile(
                leading: const Icon(IconlyLight.filter),
                title: const Text('Update Preferences'),
                onTap: () => Get.to(() => UserPreferencePage()),
              ),

            ],
          ),
          _buildSection(
            'Account',
            [
              ListTile(
                leading: const Icon(IconlyLight.profile),
                title: const Text('Edit Profile'),
                onTap: () => Get.toNamed('/edit-profile'),
              ),
              ListTile(
                leading: const Icon(IconlyLight.lock),
                title: const Text('Change Password'),
                onTap: () => Get.toNamed('/change-password'),
              ),
              ListTile(
                leading: const Icon(IconlyLight.shieldDone),
                title: const Text('Privacy Policy'),
                onTap: () => Get.toNamed('/privacy-policy'),
              ),
              ListTile(
                leading: const Icon(IconlyLight.document),
                title: const Text('Terms of Service'),
                onTap: () => Get.toNamed('/terms-of-service'),
              ),
            ],
          ),
          _buildSection(
            'Danger Zone',
            [
              ListTile(
                leading: const Icon(IconlyLight.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languages = ['English', 'Spanish', 'French', 'German'];
    Get.dialog(
      AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages
              .map((lang) => ListTile(
                    title: Text(lang),
                    onTap: () {
                      controller.setLanguage(lang);
                      Get.back();
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY'];
    Get.dialog(
      AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies
              .map((currency) => ListTile(
                    title: Text(currency),
                    onTap: () {
                      controller.setCurrency(currency);
                      Get.back();
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: controller.logout,
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
