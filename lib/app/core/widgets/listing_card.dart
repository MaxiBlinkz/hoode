import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/modules/listing_detail/listing_detail_page.dart';
import 'package:pocketbase/pocketbase.dart';

import 'card_controller.dart';

class ListingCard extends StatelessWidget {
  final RecordModel property;

  ListingCard({
    super.key,
    required this.property,
  });

  PocketBase pb = PocketBase(POCKETBASE_URL);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(() => CardController());
    final id = property.id;
    final listing = property.data;

    // TODO: fIx favourite listing toggle
    bool isFav = listing['is_favourite'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Container(
          height: 220,
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
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      // Listing Image
                      child: Image.network(
                        "$POCKETBASE_URL/api/files/properties/$id/${listing['image'][0].toString()}",
                        fit: BoxFit.cover,
                        height: 115,
                        width: 180,
                      ),
                    ),
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
                          icon: isFav
                              ? const Icon(IconlyBold.heart)
                              : const Icon(IconlyLight.heart),
                          color: Colors.red,
                          iconSize: 20.0,
                          onPressed: () async {
                            isFav = !isFav;
                            final body = <String, bool>{"is_favourite": isFav};
                            try {
                              await pb
                                  .collection('users')
                                  .update(id, body: body);
                            } catch (e) {}
                          },
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
                    listing['title'] ?? "",
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
                    listing['location']!,
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
                    "\$${listing['price']}",
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
        onTap: () {
          //listingDetailController.id = id;
          Get.to(() => const ListingDetailPage(), arguments: property);
        },
      ),
    );
  }
}
