import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../../core/config/constants.dart';
import '../../core/widgets/avatar.dart';
import 'package:logger/logger.dart';
import 'listing_detail_controller.dart';
import '../../core/widgets/listing_card.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

class ListingDetailPage extends GetView<ListingDetailController> {
  ListingDetailPage({super.key});

  final log = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.property.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load property details.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadPropertyDetails(Get.arguments as String),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final property = controller.property.value!;
        final String? imageUrl = property['images'] != null &&
                property['images'] is List &&
                (property['images'] as List).isNotEmpty
            ? property['images'][0]
            : null;
        final String title = property['title'] ?? "No Title";
        final String location = property['location'] ?? "No Location";
        final String price = property['price']?.toString() ?? "0";
        final String description = property['description'] ?? "Description";
        final String sqft = property['sqft']?.toString() ?? '0';
        final String bedrooms = property['bedrooms']?.toString() ?? '0';
        final String bathrooms = property['bathrooms']?.toString() ?? '0';

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'property-${property['id']}',
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/house_placeholder.jpg',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          'assets/images/house_placeholder.jpg',
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
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: controller.toggleBookmark,
                    )),
                IconButton(
                  icon: const Icon(IconlyLight.upload),
                  onPressed: () => controller.shareProperty(
                      title, location, price, imageUrl),
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
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(IconlyLight.location,
                            color: Colors.grey[600], size: 18),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFeature(IconlyBold.home, bedrooms, context),
                        _buildFeature(Icons.bathtub, bathrooms, context),
                        _buildFeature(
                            Icons.crop_square_outlined, '$sqft sqft', context),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 32),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 32),
                    Text(
                      'Listed by',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Obx(() => Row(
                          children: [
                            Avatar(
                              initials: controller.agentInitials.value,
                              image_url: controller.agentAvatar.value,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.agentName.value,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    controller.agentTitle.value,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 16),
                    const Divider(height: 32),
                    Text(
                      "Reviews",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Obx(() => Column(
                          children: [
                            RatingBarIndicator(
                              rating: controller.averageRating.value,
                              itemCount: 5,
                              itemSize: 24.0,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              '${controller.averageRating.value.toStringAsFixed(1)} average rating',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            if (controller.reviews.isEmpty)
                              const Center(child: Text('No reviews yet'))
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.reviews.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  final review = controller.reviews[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: review['user_avatar_url'] != null
                                          ? NetworkImage(review['user_avatar_url'])
                                          : const AssetImage("assets/images/avatar.jpg") as ImageProvider,
                                    ),
                                    title: Text(
                                      review['user_name'] ?? 'User Name',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RatingBarIndicator(
                                          rating: review['rating'] != null
                                              ? review['rating'].toDouble()
                                              : 0,
                                          itemCount: 5,
                                          itemSize: 16.0,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        Text(
                                          review['comment'] ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ElevatedButton(
                                onPressed: () =>
                                    controller.showAddReviewDialog(context),
                                child: const Text("Add a Review")),
                            const SizedBox(height: 16),
                            if (controller.similarProperties.isNotEmpty) ...[
                              Text(
                                "Similar Properties",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 310,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  itemCount:
                                      controller.similarProperties.length,
                                  itemBuilder: (context, index) {
                                    final similarProperty =
                                        controller.similarProperties[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: GestureDetector(
                                        onTap: () => controller.navigateToProperty(similarProperty['id']),
                                        child: ListingCard(
                                          property: similarProperty,
                                          imageWidth: 260,
                                          imageHeight: 150,
                                          cardHeight: 300,
                                          isFeatured: false,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.property.value == null) {
          return const SizedBox.shrink();
        }
        
        final property = controller.property.value!;
        final price = property['price']?.toString() ?? "0";
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "\$$price",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
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
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: controller.contactAgent,
                      child: Icon(IconlyBold.chat,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFeature(IconData icon, String? text, BuildContext context) {
    if (text == null || text.isEmpty || text == '0') {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
