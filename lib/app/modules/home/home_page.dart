import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../data/services/adservice.dart';
import '../listing_search/listing_search_page.dart';
import 'package:lottie/lottie.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../core/widgets/listing_card.dart';
import 'home_controller.dart';
import '../../core/theme/theme.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  final adService = AdService.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        // Removed the Avatar widget
        //title: const Text(""),
        // actions: [
        //   // IconButton(
        //   //   icon: const Icon(IconlyLight.search),
        //   //   onPressed: () => Get.to(() => const ListingSearchPage()),
        //   // ),
        //   Badge(
        //     label: const Text("2"),
        //     child: IconButton(
        //       icon: const Icon(IconlyLight.notification),
        //       onPressed: () => Get.toNamed("/messages"),
        //     ),
        //   ),
        // ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search by location, property type...",
                    hintStyle: dashboardSubTitleTextStyle,
                    border: InputBorder.none),
                onChanged: (value) => controller.searchProperties(value),
              ),
            ),
          ),
        ),
      ),
      // ... (Rest of your HomePage code)
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  buildFilterChip(
                    context: context,
                    label: "All",
                    avatar: Icon(IconlyBold.category, size: 16),
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
            // Listings Section
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
                              _buildSectionHeader(
                                  'Featured Properties', 'See All'),
                              SizedBox(
                                height: 310,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  itemCount:
                                      controller.featuredProperties.length,
                                  itemBuilder: (context, index) {
                                    final property =
                                        controller.featuredProperties[index];
                                    return ListingCard(
                                      property: property,
                                      imageWidth: 260,
                                      imageHeight: 150,
                                      cardHeight: 300,
                                      isFeatured: true,
                                      agentName: "Sarah Johnson",
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Stack(
                                    children: [
                                      // Map placeholder - integrate your map widget here
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Get.toNamed('/map'),
                                            child: const Text("View on Map"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _buildSectionHeader(
                                  'Latest Properties', 'See All'),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller
                                        .filteredProperties.length +
                                    (controller.isLoadingMore.value ? 3 : 0),
                                itemBuilder: (context, index) {
                                  if (index <
                                      controller.filteredProperties.length) {
                                    final property =
                                        controller.filteredProperties[index];
                                    return ListingCard(
                                      property: property,
                                      imageWidth: double.infinity,
                                      imageHeight: 180,
                                      cardHeight: 300,
                                      isNew: index == 0,
                                      isPriceReduced: index == 1,
                                      agentName: "David Wilson",
                                    );
                                  } else {
                                    return _buildSkeletonCard();
                                  }
                                },
                              ),
                              _buildLoadingIndicator(),
                              _buildNoMoreDataMessage(),
                              _buildAdBanner(),
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
