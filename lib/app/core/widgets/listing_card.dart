import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/services/adservice.dart';
import 'package:hoode/app/data/services/bookmarkservice.dart';
import 'package:pocketbase/pocketbase.dart';

class ListingCard extends StatelessWidget {
  final RecordModel property;
  final double? imageWidth;
  final double? imageHeight;
  final double? cardHeight;
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
  });

  void _defaultOnTap() {
    adService.interstitialAd?.show();
    Get.toNamed('/listing-details', arguments: property.id);
  }

  @override
  Widget build(BuildContext context) {
    // if (property != null) {
    //   final id = property!.id;
    //   final listing = property!.data;

    // TODO: fIx favourite listing toggle
      // bool isFav = listing['is_favourite'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap ?? _defaultOnTap,
        child: Container(
          height: cardHeight ?? 220,
          width: 180,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(66, 169, 173, 189),
                offset: Offset(0, 2),
                blurRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: property.data['image'] != null &&
                                property.data['image'].isNotEmpty
                              ? Image.network(
                                "$POCKETBASE_URL/api/files/properties/${property.id}/${property.data['image'][0].toString()}",
                                fit: BoxFit.cover,
                                height: imageHeight ?? 115,
                                width: imageWidth ?? 180)
                              : Image.asset(
                                  'assets/images/house_placeholder.jpg',
                                  fit: BoxFit.cover,
                                height: imageHeight ?? 115,
                                width: imageWidth ?? 180)),
                    Positioned(
                      top: 8,
                      left: 130,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 229, 234, 240),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(0),
                            icon:
                                bookmarkService.bookmarks.contains(property.id)
                              ? const Icon(IconlyBold.heart)
                              : const Icon(IconlyLight.heart),
                          color: Colors.red,
                          iconSize: 20.0,
                            onPressed: () =>
                              bookmarkService.toggleBookmark(property.id),
                        ),
                      ),
                    )
                  ],
                ),
                const Row(),
                const Spacer(flex: 1),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    property.data['title'] ?? "",
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(children: [
                  const Icon(
                    Icons.location_city_rounded,
                    size: 16.0,
                    color: Colors.grey,
                  ),
                  Text(
                    property.data['location']!,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                ]),
                const Spacer(flex: 2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "\$${property.data['price']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF0744BC),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    
  }
}
