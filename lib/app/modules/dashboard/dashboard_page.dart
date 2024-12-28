import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/core/widgets/market_trends_dashboard.dart';
import 'package:lottie/lottie.dart';
import 'dashboard_controller.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.isAgent.value
                ? _buildAgentDashboard(context)
                : _buildUserDashboard(context)),
      ),
    );
  }

  Widget _buildAgentDashboard(BuildContext context) {
    return CustomScrollView(
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
                    controller.user.value?.data['name'] ?? 'Agent',
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
                    _buildStatCard('Properties', 
                        controller.listingsCount.toString()),
                    _buildStatCard('Messages', '12'),
                    _buildStatCard('Bookings', '5'),
                  ],
                ),
              ),
              // Add Market Trends Dashboard
              Obx(() => MarketTrendsDashboard(
                    priceTrend: controller.marketPriceTrend,
                    demandTrend: controller.marketDemandTrend,
                    propertyTypes: controller.propertyTypeTrends,
                    revenue: controller.monthlyRevenue,
                  )),
              _buildActionButton(
                'My Properties',
                IconlyBold.home,
                controller.navigateToMyListings,
              ),
              _buildActionButton(
                'Add Property',
                IconlyBold.plus,
                controller.navigateToAddListing,
              ),
              _buildActionButton(
                'Messages',
                IconlyBold.chat,
                controller.navigateToMessages,
              ),
              _buildActionButton(
                'Analytics',
                IconlyBold.chart,
                controller.navigateToAnalytics,
              ),
              _buildActionButton(
                'Bookings',
                IconlyBold.calendar,
                controller.navigateToBookings,
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
    );
  }

  Widget _buildUserDashboard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/agent.json',
            height: 200,
          ),
          const SizedBox(height: 24),
          const Text(
            'Become a Real Estate Agent',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Join our network of professional agents and unlock these features:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          _buildFeatureItem('List and manage properties'),
          _buildFeatureItem('Connect with potential buyers'),
          _buildFeatureItem('Track property views and interests'),
          _buildFeatureItem('Manage bookings and appointments'),
          _buildFeatureItem('Access detailed analytics'),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: controller.becomeAgent,
              child: const Text(
                'Become an Agent',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
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
