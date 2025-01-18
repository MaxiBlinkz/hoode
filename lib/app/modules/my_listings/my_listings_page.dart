import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../../core/widgets/listing_card.dart';
import 'my_listings_controller.dart';

class MyListingsPage extends GetView<MyListingsController> {
  const MyListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
        leading: IconButton(
          icon: const Icon(IconlyLight.arrowLeft2),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.listings.length,
              itemBuilder: (context, index) {
                final listing = controller.listings[index];
                return Dismissible(
                  key: Key(listing.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(IconlyBold.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => controller.deleteListing(listing.id),
                  child: ListingCard(
                    property: listing,
                    onTap: () => controller.editListing(listing.id),
                  ),
                );
              }
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-listing'),
        child: const Icon(IconlyBold.plus),
      ),
    );
  }
}
