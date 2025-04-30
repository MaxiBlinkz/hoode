import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../../data/services/adservice.dart';
import '../../data/services/bookmarkservice.dart';

class ListingCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final double? imageWidth;
  final double? imageHeight;
  final double? cardHeight;
  final bool isFeatured;
  final bool isNew;
  final bool isPriceReduced;
  final String? agentName;
  final bookmarkService = Get.find<BookmarkService>();
  final adService = AdService.to;
  final VoidCallback? onTap;

  ListingCard({
    super.key,
    required this.property,
    this.imageWidth,
    this.imageHeight,
    this.cardHeight,
    this.onTap,
    this.isFeatured = false,
    this.isNew = false,
    this.isPriceReduced = false,
    this.agentName,
  });

  @override
  Widget build(BuildContext context) {
    // Extract property data from the Map
    final String? imageUrl = property['images'] != null &&
            property['images'] is List &&
            property['images'].isNotEmpty
        ? property['images'][0]
        : null;
    final String title = property['title']?.toString() ?? "No Title";
    final String location = property['location']?.toString() ?? "No Location";
    final String price = property['price']?.toString() ?? "0";
    final int bedrooms = property['bedrooms'] ?? 0;
    final int bathrooms = property['bathrooms'] ?? 0;
    final String sqft = property['sqft']?.toString() ?? "0";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: GestureDetector(
        onTap: onTap ?? () => _defaultOnTap(property),
        child: Container(
          width: imageWidth,
          height: cardHeight ?? 240,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            height: imageHeight ?? 140,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/house_placeholder.jpg',
                              fit: BoxFit.cover,
                              height: imageHeight ?? 140,
                              width: double.infinity,
                            ),
                          )
                        : Image.asset(
                            'assets/images/house_placeholder.jpg',
                            fit: BoxFit.cover,
                            height: imageHeight ?? 140,
                            width: double.infinity,
                          ),
                  ),
                  if (isFeatured)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue,
                        ),
                        child: Text(
                          "Featured",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                  if (isNew)
                    Positioned(
                      top: 10,
                      left: isFeatured ? 90 : 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green,
                        ),
                        child: Text(
                          "New",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                  if (isPriceReduced)
                    Positioned(
                      top: 10,
                      left: (isFeatured && isNew) ? 150 : (isFeatured || isNew) ? 90 : 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.orange,
                        ),
                        child: Text(
                          "Price Reduced",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Obx(() => Icon(
                              bookmarkService.bookmarks.contains(property['id'])
                                  ? IconlyBold.heart
                                  : IconlyLight.heart,
                              color: Colors.red,
                              size: 20,
                            )),
                        onPressed: () => bookmarkService.toggleBookmark(property['id']),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          IconlyLight.location,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$$price",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Row(
                          children: [
                            _buildFeatureIcon(IconlyLight.home, "$bedrooms"),
                            const SizedBox(width: 12),
                            _buildFeatureIcon(IconlyLight.discovery, "$bathrooms"),
                            const SizedBox(width: 12),
                            _buildFeatureIcon(Icons.crop_square_outlined, "$sqft sqft"),
                          ],
                        ),
                      ],
                    ),
                    if (agentName != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 12,
                            backgroundImage: AssetImage("assets/images/avatar.jpg"),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            agentName!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          count,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _defaultOnTap(Map<String, dynamic> property) {
    Get.toNamed('/listing-detail', arguments: property);
  }
}