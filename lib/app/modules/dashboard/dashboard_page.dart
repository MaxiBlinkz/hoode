import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../../core/widgets/market_trends_dashboard.dart';
import 'package:lottie/lottie.dart';
import 'dashboard_controller.dart';
import '../../core/widgets/listing_card.dart';
import 'package:pocketbase/pocketbase.dart';

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
          expandedHeight: 150,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dashboard",
                             style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Welcome back, ${controller.user.value?.data['name'] ?? 'Agent'}",
                               style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(IconlyLight.notification),
                        onPressed: () => Get.toNamed("/messages"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                 child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2, // Display 2 cards in a row
                      childAspectRatio: 1.5,
                      mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                      children: [
                    _buildStatCard(
                      context,
                      IconlyLight.home,
                      'Active Listings',
                      controller.listingsCount.toString(),
                    ),
                    _buildStatCard(
                      context,
                      IconlyLight.show,
                      'Total Views',
                       controller.totalViews.toString()
                    ),
                    _buildStatCard(
                      context,
                      IconlyLight.user2,
                      'New Leads',
                      controller.newLeads.toString(),
                    ),
                     _buildStatCard(
                      context,
                       IconlyLight.wallet,
                      'Revenue',
                      '\$52K',
                    ),
                ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text("Active Listings", style: Theme.of(context).textTheme.titleLarge,),
              ),
                 SizedBox(
                    height: 310,
                    child: Obx(() =>  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: controller.activeListings.length,
                      itemBuilder: (context, index) {
                         return Obx(() =>
                            controller.activeListings.isNotEmpty ?
                                  ListingCard(
                                    property: controller.activeListings[index],
                                      imageWidth: 260,
                                      imageHeight: 150,
                                      cardHeight: 300,
                                      isFeatured: false,
                                      agentName: "Sarah Johnson",
                                    ) : const Text("No Properties Listed"),
                         );
                      },
                    ),)
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                     child: Text("Recent Activities", style: Theme.of(context).textTheme.titleLarge,),
                  ),
                  _buildRecentActivity(context, IconlyLight.user2, "New Lead", "Sarah Johnson requested a viewing", "2h ago"),
                  _buildRecentActivity(context, IconlyLight.home, "Property Update", "Price reduced for 123 Luxury Ave", "4h ago"),
                  _buildRecentActivity(context, IconlyLight.document, "Offer Received", "New offer for 456 Elite St", "6h ago"),

                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Text("Quick Actions", style: Theme.of(context).textTheme.titleLarge,),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            _buildQuickActionButton(context, IconlyLight.plus, "Add Property", () {}),
                            _buildQuickActionButton(context, IconlyLight.calendar, "Schedule Tour", () {}),
                             _buildQuickActionButton(context, IconlyLight.chat, "Messages", () {}),
                            _buildQuickActionButton(context, IconlyLight.chart, "Analytics", () {}),
                         ],
                      ),
                  ),

                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Text("Upcoming Appointments", style: Theme.of(context).textTheme.titleLarge,),
                  ),

                  _buildAppointment(context,"10:00 AM", "Michael Brown", "123 Luxury Ave", "Confirmed"),
                    _buildAppointment(context,"2:30 PM", "Emma Wilson", "456 Elite St", "Pending"),
                    _buildAppointment(context,"4:00 PM", "James Davis", "789 Premium Rd", "Confirmed"),
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
                backgroundColor: Theme.of(context).primaryColor,
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

  Widget _buildStatCard(BuildContext context, IconData icon, String title, String value) {
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
         Icon(icon, color: Theme.of(context).colorScheme.primary, size: 30,),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
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

    Widget _buildRecentActivity(BuildContext context, IconData icon, String title, String subtitle, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading:  CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              child: Icon(icon, color: Theme.of(context).colorScheme.primary)
          ),
          title: Text(title, style: Theme.of(context).textTheme.bodyMedium,),
           subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall,),
          trailing:  Text(time, style: Theme.of(context).textTheme.bodySmall,),
        ),
    );
  }

   Widget _buildQuickActionButton(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return  Column(
        children: [
           CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              child: IconButton(
                icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
                onPressed: onTap,
              ),
          ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodySmall,)
          ],
        );
  }
    Widget _buildAppointment(BuildContext context, String time, String name, String address, String status) {
    return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(time, style: Theme.of(context).textTheme.bodyMedium,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                color: status == "Confirmed" ? Colors.green.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(5)
                 ),
                 child:  Text(status, style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: status == "Confirmed" ? Colors.green.shade900 : Colors.orange.shade900
                   )
                 )
              ),
          ],
        ),
         subtitle:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.bodyMedium,),
            Text(address, style: Theme.of(context).textTheme.bodySmall,),
          ],
         )
        ),
    );
  }
}