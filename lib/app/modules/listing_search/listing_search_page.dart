import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/core/widgets/listing_card.dart';
import 'listing_search_controller.dart';
import 'dart:math' as math;


class ListingSearchPage extends GetView<ListingSearchController> {
  const ListingSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search properties...',
                  prefixIcon: const Icon(IconlyLight.search),
                  suffixIcon: IconButton(
                    icon: const Icon(IconlyLight.filter),
                    onPressed: () => _showFilterBottomSheet(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: controller.updateSearchQuery,
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
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ExpansionTile(
                  title: const Text('Price Range'),
                  children: [
                    RangeSlider(
                      values: controller.priceRange.value,
                      min: 0,
                      max: 1000000,
                      divisions: 100,
                      labels: RangeLabels(
                        '\$${controller.priceRange.value.start.toInt()}',
                        '\$${controller.priceRange.value.end.toInt()}',
                      ),
                      onChanged: controller.updatePriceRange,
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text('Features'),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFeatureCounter('Beds', controller.bedrooms),
                        _buildFeatureCounter('Baths', controller.bathrooms),
                      ],
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text('Location'),
                  children: [
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
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.applyFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ),
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
