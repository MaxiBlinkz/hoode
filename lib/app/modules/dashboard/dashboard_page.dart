import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'dashboard_controller.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: AppColors.primary,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/images/avatar.jpg'),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'John Doe',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatCard('My Listings', 
                                  controller.listingsCount.toString()),
                              _buildStatCard('Saved', 
                                  controller.savedListingsCount.toString()),
                            ],
                          ),
                        ),
                        _buildActionButton(
                          'My Listings',
                          IconlyBold.home,
                          controller.navigateToMyListings,
                        ),
                        _buildActionButton(
                          'Add New Listing',
                          IconlyBold.plus,
                          controller.navigateToAddListing,
                        ),
                        _buildActionButton(
                          'Settings',
                          IconlyBold.setting,
                          controller.navigateToSettings,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: onTap,
    );
  }
}
