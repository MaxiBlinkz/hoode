import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../data/services/adservice.dart';
import 'package:lottie/lottie.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
            // Search Bar
            Padding(
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
                      // Add filter action
                    },
                  ),
                ],
              ),
            ),
            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  buildFilterChip(
                    context: context,
                    label: "All",
                    avatar: const Icon(IconlyBold.category, size: 16),
                    filterValue: '',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "House",
                    avatar: Icon(IconlyBold.home, size: 16),
                    filterValue: 'house',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "Apartment",
                    avatar: Icon(FlutterRemix.building_2_fill, size: 16),
                    filterValue: 'apartment',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "Villa",
                    avatar: Icon(FlutterRemix.building_4_fill, size: 16),
                    filterValue: 'villa',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "Condo",
                    avatar: Icon(FlutterRemix.building_3_fill, size: 16),
                    filterValue: 'condo',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "Townhouse",
                    avatar: Icon(FlutterRemix.home_4_fill, size: 16),
                    filterValue: 'townhouse',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "Studio",
                    avatar: Icon(FlutterRemix.home_5_fill, size: 16),
                    filterValue: 'studio',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "Penthouse",
                    avatar: Icon(FlutterRemix.building_fill, size: 16),
                    filterValue: 'penthouse',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "Loft",
                    avatar: Icon(FlutterRemix.building_line, size: 16),
                    filterValue: 'loft',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "Hotel",
                    avatar: Icon(FlutterRemix.building_fill, size: 16),
                    filterValue: 'hotel',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "Motel",
                    avatar: Icon(FlutterRemix.building_line, size: 16),
                    filterValue: 'motel',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "Guesthouse",
                    avatar: Icon(FlutterRemix.building_fill, size: 16),
                    filterValue: 'guesthouse',
                  ),
                  buildFilterChip(
                    context: context,
                    label: "Cottage",
                    avatar: Icon(FlutterRemix.building_line, size: 16),
                    filterValue: 'cottage',
                  ),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.loadProperties(),
                child: Obx(
                  () => controller.hasError.value
                      ? _buildErrorView()
                      : SingleChildScrollView(
                          controller: controller.listController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader('Featured Properties', 'See All'),
                              SizedBox(
                                height: 280,
                                child: ListView.builder(
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
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Map Section
                              Padding(
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
                              ),
                              _buildSectionHeader('Latest Properties', 'See All'),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: ListView.builder(
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
                                      ),
                                    );
                                  },
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
      ),
    );
  }
  Widget _buildSectionHeader(String title, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(onPressed: () {}, child: Text(buttonText)),
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
          const Text('Oops! Connection Error',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
        property: RecordModel(),
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
              child: Lottie.asset('assets/animations/loading_more.json',
                  height: 50, width: 50),
            ),
          )
        : const SizedBox());
  }

  Widget _buildNoMoreDataMessage() {
    return Obx(
        () => !controller.isLoadingMore.value && !controller.hasMoreData.value
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No more properties to load",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
              )
            : const SizedBox());
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
      _buildSectionHeader('Recommended For You', 'See All'),
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
              //agentName: property.agentName,
            );
          },
        ),
      ),
    ],
  );
}


  Widget buildFilterChip({
    required BuildContext context,
    required String label,
    required Widget avatar,
    required String filterValue,
  }) {
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
            shadowColor: Theme.of(context).shadowColor.withValues(
                  red: 0,
                  green: 0,
                  blue: 0,
                  alpha: 10,
                ),
          ),
        ));
  }
}
