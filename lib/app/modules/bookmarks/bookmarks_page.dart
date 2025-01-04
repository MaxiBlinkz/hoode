import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
// import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/core/widgets/listing_card.dart';
import 'bookmarks_controller.dart';

class BookmarksPage extends GetView<BookmarksController> {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Saved Listings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(IconlyLight.filter),
                    onPressed: () {
                      // Implement filter functionality
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (controller.bookmarkedListings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(IconlyBold.bookmark, 
                             size: 64, 
                             color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No saved listings yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Get.toNamed('/home'),
                          child: const Text('Browse Listings'),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    childAspectRatio: 0.6,
                  ),
                  padding: const EdgeInsets.all(2),
                  itemCount: controller.bookmarkedListings.length,
                  itemBuilder: (context, index) {
                    final listing = controller.bookmarkedListings[index];
                    return Dismissible(
                      key: Key(listing.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        color: Colors.red,
                        child: const Icon(IconlyBold.delete, 
                                        color: Colors.white),
                      ),
                      onDismissed: (_) => 
                          controller.removeBookmark(listing.id),
                      child: ListingCard(
                        property: listing,
                        imageWidth: double.infinity,
                        imageHeight: 120,
                        cardHeight: 240,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
