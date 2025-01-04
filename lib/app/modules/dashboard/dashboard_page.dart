import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../../core/theme/colors.dart';
import '../../core/widgets/market_trends_dashboard.dart';
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
                    _buildStatCard(context, 'Properties',
                        controller.listingsCount.toString()),
                    _buildStatCard(context, 'Messages', '12'),
                    _buildStatCard(context, 'Bookings', '5'),
                  ],
                ),
              ),
              // Add Market Trends Dashboard
              MarketTrendsDashboard(
                    priceTrend: controller.marketPriceTrend,
                    demandTrend: controller.marketDemandTrend,
                    propertyTypes: controller.propertyTypeTrends,
                    revenue: controller.monthlyRevenue,
                  ),
              _buildActionButton(
                context, 
                'My Properties',
                IconlyBold.home,
                controller.navigateToMyListings,
              ),
              _buildActionButton(
                context, 
                'Add Property',
                IconlyBold.plus,
                controller.navigateToAddListing,
              ),
              _buildActionButton(
                context, 
                'Messages',
                IconlyBold.chat,
                controller.navigateToMessages,
              ),
              _buildActionButton(
                context, 
                'Analytics',
                IconlyBold.chart,
                controller.navigateToAnalytics,
              ),
              _buildActionButton(
                context, 
                'Bookings',
                IconlyBold.calendar,
                controller.navigateToBookings,
              ),
              _buildActionButton(
                context, 
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
          _buildFeatureItem(context, 'List and manage properties'),
          _buildFeatureItem(context, 'Connect with potential buyers'),
          _buildFeatureItem(context, 'Track property views and interests'),
          _buildFeatureItem(context, 'Manage bookings and appointments'),
          _buildFeatureItem(context, 'Access detailed analytics'),
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
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(
                  red: 0,
                  green: 0,
                  blue: 0,
                  alpha: 0.2,
                ),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      trailing: Icon(
        IconlyLight.arrowRight2,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
