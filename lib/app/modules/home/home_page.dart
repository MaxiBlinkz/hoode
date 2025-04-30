import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../data/services/adservice.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/widgets/listing_card.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  final adService = AdService.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilterChips(),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  // MARK: - UI Components

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search by location, property type...",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) => controller.searchProperties(value),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              // Show filter dialog
              _showFilterDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          buildFilterChip(
            label: "All",
            avatar: const Icon(IconlyBold.category, size: 16),
            filterValue: '',
          ),
          buildFilterChip(
            label: "House",
            avatar: const Icon(IconlyBold.home, size: 16),
            filterValue: 'house',
          ),
          buildFilterChip(
            label: "Apartment",
            avatar: const Icon(FlutterRemix.building_2_fill, size: 16),
            filterValue: 'apartment',
          ),
          buildFilterChip(
            label: "Villa",
            avatar: const Icon(FlutterRemix.building_4_fill, size: 16),
            filterValue: 'villa',
          ),
          buildFilterChip(
            label: "Condo",
            avatar: const Icon(FlutterRemix.building_3_fill, size: 16),
            filterValue: 'condo',
          ),
          buildFilterChip(
            label: "Townhouse",
            avatar: const Icon(FlutterRemix.home_4_fill, size: 16),
            filterValue: 'townhouse',
          ),
          buildFilterChip(
            label: "Studio",
            avatar: const Icon(FlutterRemix.home_5_fill, size: 16),
            filterValue: 'studio',
          ),
          buildFilterChip(
            label: "Penthouse",
            avatar: const Icon(FlutterRemix.building_fill, size: 16),
            filterValue: 'penthouse',
          ),
          buildFilterChip(
            label: "Loft",
            avatar: const Icon(FlutterRemix.building_line, size: 16),
            filterValue: 'loft',
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => controller.loadProperties(),
        child: Obx(
          () => controller.hasError.value
              ? _buildErrorView()
              : controller.isLoading.value
                  ? _buildLoadingView()
                  : _buildPropertyListings(),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return ListView.builder(
      itemCount: 3,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildPropertyListings() {
    return SingleChildScrollView(
      controller: controller.listController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Properties Section
          _buildSectionHeader('Featured Properties', 'See All', 
            onSeeAllPressed: () => Get.toNamed('/featured-properties')),
          _buildFeaturedPropertiesCarousel(),
          
          // Map Section
          _buildMapSection(),
          
          // Recommendations Section (if available)
          if (controller.recommendedProperties.isNotEmpty)
            _buildRecommendationsSection(),
            
          // Latest Properties Section
          _buildSectionHeader('Latest Properties', 'See All',
            onSeeAllPressed: () => Get.toNamed('/all-properties')),
          _buildLatestPropertiesList(),
          
          // Loading indicator and end of list message
          _buildLoadingIndicator(),
          _buildNoMoreDataMessage(),
          
          // Ad Banner
          _buildAdBanner(),
          
          // Bottom padding
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFeaturedPropertiesCarousel() {
    return SizedBox(
      height: 280,
      child: Obx(() => controller.featuredProperties.isEmpty
          ? _buildEmptyFeaturedProperties()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: controller.featuredProperties.length,
              itemBuilder: (context, index) {
                final property = controller.featuredProperties[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ListingCard(
                    property: property,
                    imageWidth: 280,
                    imageHeight: 160,
                    cardHeight: 270,
                    isFeatured: true,
                    agentName: "Sarah Johnson",
                    onTap: () {
                      controller.viewProperty(property['id']);
                      Get.toNamed('/listing-detail', arguments: property);
                    },
                  ),
                );
              },
            )),
    );
  }

  Widget _buildEmptyFeaturedProperties() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_work_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No featured properties available',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Stack(
          children: [
            // Map placeholder
            Center(
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/map'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text("View on Map"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestPropertiesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() => controller.filteredProperties.isEmpty
          ? _buildEmptyPropertyList()
          : ListView.builder(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredProperties.length,
              itemBuilder: (context, index) {
                final property = controller.filteredProperties[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ListingCard(
                    property: property,
                    imageWidth: double.infinity,
                    imageHeight: 200,
                    cardHeight: 320,
                    isNew: index == 0,
                    isPriceReduced: index == 1,
                    agentName: "Emily Davis",
                    onTap: () {
                      controller.viewProperty(property['id']);
                      Get.toNamed('/listing-detail', arguments: property);
                    },
                  ),
                );
              },
            )),
    );
  }

  Widget _buildEmptyPropertyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/empty_list.json', 
            width: 200, height: 200),
          const Text(
            'No properties found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              controller.searchQuery.value = '';
              controller.selectedFilter.value = '';
              controller.loadProperties();
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String buttonText, {VoidCallback? onSeeAllPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          TextButton(
            onPressed: onSeeAllPressed ?? () {}, 
            child: Text(buttonText)
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/oops.json', width: 200, height: 200),
          const Text(
            'Oops! Connection Error',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.retryLoading,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Skeletonizer(
      enabled: true,
      child: ListingCard(
        property: {
          'id': 'skeleton',
          'title': 'Loading Property',
          'location': 'Loading Location',
          'price': '0',
          'bedrooms': 0,
          'bathrooms': 0,
          'sqft': '0',
          'images': []
        },
        imageWidth: double.infinity,
        imageHeight: 180,
        cardHeight: 300,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Obx(() => controller.isLoadingMore.value
        ? SizedBox(
            height: 100,
            child: Center(
              child: Lottie.asset(
                'assets/animations/loading_more.json',
                height: 50, 
                width: 50
              ),
            ),
          )
        : const SizedBox());
  }

  Widget _buildNoMoreDataMessage() {
    return Obx(
      () => !controller.isLoadingMore.value && !controller.hasMoreData.value
          ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No more properties to load",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)
              ),
            )
          : const SizedBox()
    );
  }

  Widget _buildAdBanner() {
    return SizedBox(
      height: 50,
      child: AdWidget(ad: AdService.to.createUniqueBannerAd()),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Recommended For You', 'See All',
          onSeeAllPressed: () => Get.toNamed('/recommended-properties')),
        SizedBox(
          height: 310,
          child: ListView.builder(
                        scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: controller.recommendedProperties.length,
            itemBuilder: (context, index) {
              final property = controller.recommendedProperties[index];
              return ListingCard(
                property: property,
                imageWidth: 260,
                imageHeight: 150,
                cardHeight: 300,
                onTap: () {
                  controller.viewProperty(property['id']);
                  Get.toNamed('/listing-detail', arguments: property);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    // Price range variables
    RangeValues priceRange = const RangeValues(0, 1000000);
    int minBedrooms = 0;
    int minBathrooms = 0;

    final context = Get.context!;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Properties',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  
                  // Price Range
                  const Text(
                    'Price Range',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RangeSlider(
                    values: priceRange,
                    min: 0,
                    max: 1000000,
                    divisions: 20,
                    labels: RangeLabels(
                      '\$${priceRange.start.round()}',
                      '\$${priceRange.end.round()}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        priceRange = values;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${priceRange.start.round()}'),
                      Text('\$${priceRange.end.round()}'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Bedrooms
                  const Text(
                    'Minimum Bedrooms',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (int i = 0; i <= 5; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(i == 5 ? '5+' : '$i'),
                            selected: minBedrooms == i,
                            onSelected: (selected) {
                              setState(() {
                                minBedrooms = selected ? i : 0;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Bathrooms
                  const Text(
                    'Minimum Bathrooms',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (int i = 0; i <= 5; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(i == 5 ? '5+' : '$i'),
                            selected: minBathrooms == i,
                            onSelected: (selected) {
                              setState(() {
                                minBathrooms = selected ? i : 0;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Property Features
                  const Text(
                    'Property Features',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      _buildFeatureChip('Pool', false, setState),
                      _buildFeatureChip('Garden', false, setState),
                      _buildFeatureChip('Garage', false, setState),
                      _buildFeatureChip('Air Conditioning', false, setState),
                      _buildFeatureChip('Gym', false, setState),
                      _buildFeatureChip('Balcony', false, setState),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Apply and Reset buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Reset all filters
                            setState(() {
                              priceRange = const RangeValues(0, 1000000);
                              minBedrooms = 0;
                              minBathrooms = 0;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Apply filters
                            // You would need to add filter parameters to your controller
                            // controller.applyFilters(priceRange, minBedrooms, minBathrooms);
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeatureChip(String label, bool selected, StateSetter setState) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (bool value) {
        setState(() {
          // Update selected state
        });
      },
    );
  }

  Widget buildFilterChip({
    required String label,
    required Widget avatar,
    required String filterValue,
  }) {

    final context = Get.context!;
    return Obx(() => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: FilterChip(
            showCheckmark: false,
            label: Text(label),
            avatar: avatar,
            selected: controller.selectedFilter.value == filterValue,
            onSelected: (selected) {
              controller.filterProperties(selected ? filterValue : '');
            },
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            labelStyle: TextStyle(
              color: controller.selectedFilter.value == filterValue
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
            shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
          ),
        ));
  }
}
