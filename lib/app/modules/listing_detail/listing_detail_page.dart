import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/core/widgets/avatar.dart';
import 'package:logger/logger.dart';
import 'listing_detail_controller.dart';

class ListingDetailPage extends GetView<ListingDetailController> {
  ListingDetailPage({super.key});

  Logger log = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        log.i('Property value: ${controller.property.value}');
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final property = controller.property.value;
        if (property == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load property details.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      controller.loadPropertyDetails(Get.arguments as String),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }


        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'property-${property.id}',
                  child: Image.network(
                    '$POCKETBASE_URL/api/files/properties/${property.id}/${property.data['image'][0].toString()}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(IconlyLight.arrowLeft2),
                onPressed: () => Get.back(),
              ),
              actions: [
                Obx(() => IconButton(
                      icon: Icon(
                        controller.isBookmarked.value
                            ? IconlyBold.bookmark
                            : IconlyLight.bookmark,
                        color: AppColors.primary,
                      ),
                      onPressed: controller.toggleBookmark,
                    )),
                IconButton(
                  icon: const Icon(IconlyLight.send),
                  onPressed: () {/* Share functionality */},
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.data['title'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(IconlyLight.location,
                            color: Colors.grey[600], size: 18),
                        const SizedBox(width: 4),
                        Text(
                          property.data['location'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFeature(IconlyBold.home,
                            '${property.data['bedrooms']} Beds'),
                        _buildFeature(Icons.bathtub,
                            '${property.data['bathrooms']} Baths'),
                        _buildFeature(
                            IconlyBold.chart, '${property.data['area']} sqft'),
                      ],
                    ),
                    const Divider(height: 32),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(property.data['description']),
                    const Divider(height: 32),
                    const Text(
                      'Listed by',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Avatar(
                          initials: "MK",
                          image_url: "assets/images/avatar.jpg",
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.data['agent_name'] ?? 'Agent Name',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                property.data['agent_title'] ??
                                    'Real Estate Agent',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),                    
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      // In the bottomNavigationBar section, update the Row widget:
bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "\${controller.property.value?.data['price']}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(IconlyLight.chat),
              onPressed: () => Get.toNamed('/chat-view', arguments: {
                'agentId': controller.property.value?.data['agent'],
                'propertyId': controller.property.value?.id,
              }),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.contactAgent,
                child: const Text('Contact Agent'),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(text),
      ],
    );
  }
}
