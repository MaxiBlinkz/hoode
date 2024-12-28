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
    final property = controller.property.value!;
    final String? imageUrl = property.data['image'] != null &&
            property.data['image'] is List &&
            property.data['image'].isNotEmpty
        ? "$POCKETBASE_URL/api/files/properties/${property.id}/${property.data['image'][0].toString()}"
        : null;
    final String title = property.data['title']?.toString() ?? "No Title";
    final String location =
        property.data['location']?.toString() ?? "No Location";
    final String price = property.data['price']?.toString() ?? "0";
    final String description =
        property.data['description']?.toString() ?? "Description";
    
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }


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
                  child: imageUrl != null
                      ? Image.network(
                    '$POCKETBASE_URL/api/files/properties/${property.id}/${property.data['image'][0].toString()}',
                    fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                'assets/images/house_placeholder.jpg',
                              ))
                      : Image.asset(
                          'assets/images/house_placeholder.jpg',
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
                      title,
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
                          location,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFeature(IconlyBold.home,
                            property.data['bedrooms']?.toString()),
                        _buildFeature(Icons.bathtub,
                            property.data['bathrooms']?.toString()),
                        _buildFeature(
                            IconlyBold.chart,
                            property.data['area']?.toString() != null
                                ? '${property.data['area']} sqft'
                                : null),
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
                    Text(description),
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
bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Price",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "\$$price",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
              child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: controller.bookProperty,
                      child: Obx(() => Text(
                            controller.isBooked.value ? 'Booked' : 'Book Now',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: controller.contactAgent,
                    child: const Icon(IconlyBold.chat),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildFeature(IconData icon, String? text) {
    if (text == null || text.isEmpty || text == '0') {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(text),
      ],
    );
  }

}
