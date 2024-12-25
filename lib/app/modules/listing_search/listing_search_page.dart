import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/core/widgets/listing_card.dart';
import 'listing_search_controller.dart';

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
              child: SearchAnchor.bar(
                barHintText: 'Search properties...',
                barLeading: IconButton(
                  icon: const Icon(IconlyLight.arrowLeft2),
                  onPressed: () => Get.back(),
                ),
                onSubmitted: (value) => controller.updateSearchQuery(value),
                suggestionsBuilder: (context, controller) {
                  return List<ListTile>.generate(5, (index) {
                    return ListTile(
                      leading: const Icon(IconlyLight.search),
                      title: Text('Suggestion $index'),
                      onTap: () {
                        controller.closeView(controller.text);
                      },
                    );
                  });
                },
              ),
            ),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildFilterChip(
                    'Price Range',
                    IconlyLight.wallet,
                    () => _showPriceRangeDialog(context),
                  ),
                  _buildFilterChip(
                    'Property Type',
                    IconlyLight.home,
                    () => _showPropertyTypeDialog(context),
                  ),
                  _buildFilterChip(
                    'Bedrooms',
                    Icons.bed,
                    () => _showBedroomsDialog(context),
                  ),
                  _buildFilterChip(
                    'Location',
                    IconlyLight.location,
                    () => _showLocationDialog(context),
                  ),
                ],
              ),
            ),

            Obx(() => Wrap(
                  spacing: 8,
                  children: controller.activeFilters.map((filter) {
                    return Chip(
                      label: Text(filter),
                      deleteIcon: const Icon(IconlyLight.closeSquare, size: 18),
                      onDeleted: () => controller.removeFilter(filter),
                    );
                  }).toList(),
                )),

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
      floatingActionButton: FloatingActionButton(
        onPressed: controller.clearFilters,
        child: const Icon(IconlyLight.delete),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(icon, size: 18, color: AppColors.primary),
        label: Text(label),
        onPressed: onTap,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  void _showPriceRangeDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Price Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RangeSlider(
              values: RangeValues(0, 1000000),
              max: 1000000,
              divisions: 100,
              labels: RangeLabels('\$0', '\$1M'),
              onChanged: (RangeValues values) {
                controller.setPriceRange(values.start, values.end);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showPropertyTypeDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Property Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('House'),
              onTap: () {
                controller.setPropertyType('House');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Apartment'),
              onTap: () {
                controller.setPropertyType('Apartment');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Villa'),
              onTap: () {
                controller.setPropertyType('Villa');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBedroomsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Bedrooms'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return ListTile(
              title: Text('${index + 1} Bedrooms'),
              onTap: () {
                controller.setBedrooms(index + 1);
                Get.back();
              },
            );
          }),
        ),
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('New York'),
              onTap: () {
                controller.setLocation('New York');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Los Angeles'),
              onTap: () {
                controller.setLocation('Los Angeles');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Chicago'),
              onTap: () {
                controller.setLocation('Chicago');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
