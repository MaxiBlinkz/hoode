import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../../core/widgets/listing_card.dart';
import 'listing_search_controller.dart';
import 'dart:math' as math;

class ListingSearchPage extends GetView<ListingSearchController> {
  const ListingSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Find Your Dream Home',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(IconlyLight.notification),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterChip(
                              label: const Text('All'),
                              selected: true,
                              onSelected: (bool selected) {},
                            ),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: const Text('House'),
                              selected: false,
                              onSelected: (bool selected) {},
                            ),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: const Text('Apartment'),
                              selected: false,
                              onSelected: (bool selected) {},
                            ),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: const Text('Villa'),
                              selected: false,
                              onSelected: (bool selected) {},
                            ),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: const Text('Studio'),
                              selected: false,
                              onSelected: (bool selected) {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.searchResults.length,
                          itemBuilder: (context, index) {
                            final property = controller.searchResults[index];
                            return ListingCard(property: property);
                          },
                        )),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.13,
            minChildSize: 0.125,
            maxChildSize: 0.9,
            builder: (context, scrollController) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search properties...',
                          prefixIcon: const Icon(IconlyLight.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onChanged: controller.updateSearchQuery,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Price Range',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Obx(() => RangeSlider(
                            values: controller.priceRange.value,
                            min: 0,
                            max: 1000000,
                            divisions: 100,
                            labels: RangeLabels(
                              '\$${controller.priceRange.value.start.toInt()}',
                              '\$${controller.priceRange.value.end.toInt()}',
                            ),
                            onChanged: controller.updatePriceRange,
                          )),
                      const SizedBox(height: 20),
                      const Text(
                        'Features',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFeatureCounter('Beds', controller.bedrooms),
                          _buildFeatureCounter('Baths', controller.bathrooms),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Location',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: controller.locationController,
                        decoration: InputDecoration(
                          hintText: 'Enter location',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: controller.useCurrentLocation,
                          ),
                        ),
                        onChanged: controller.geocodeAddress,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.applyFilters();
                          },
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCounter(String label, RxInt value) {
    return Column(
      children: [
        Text(label),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => value.value = math.max(0, value.value - 1),
            ),
            Obx(() => Text('${value.value}')),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => value.value++,
            ),
          ],
        ),
      ],
    );
  }
}
