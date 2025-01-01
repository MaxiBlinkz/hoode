import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:hoode/app/core/widgets/category_item.dart';
import 'package:hoode/app/data/services/adservice.dart';
import 'package:hoode/app/modules/listing_search/listing_search_page.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:lottie/lottie.dart';
import 'package:pocketbase/pocketbase.dart';
// import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/theme/colors.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/listing_card.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  final adService = AdService.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          title: const Avatar(
            initials: "MK",
            image_url: "assets/images/avatar.jpg",
          ),
          actions: [
            IconButton(
              icon: const Icon(IconlyLight.search),
              onPressed: () => Get.to(() => const ListingSearchPage()),
            ),
            Badge(
              label: const Text("2"),
              child: IconButton(
                icon: const Icon(
                  IconlyLight.notification,
                  color: AppColors.primary,
                ),
                iconSize: 20.0,
                onPressed: () {
                  Get.toNamed("/messages");
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => controller.loadProperties(),
            child: Obx(
              () => controller.hasError.value
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animations/oops.json',
                            width: 200,
                            height: 200,
                          ),
                          const Text(
                            'Oops! Connection Error',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.retryLoading,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      controller: controller.listController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8.0),
                          // Horizontal category list
                          SizedBox(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                                  avatar: Icon(FlutterRemix.building_2_fill,
                                      size: 16),
                                  filterValue: 'apartment',
                                ),
                                buildFilterChip(
                                  context: context,
                                  label: "Villa",
                                  avatar: Icon(FlutterRemix.building_4_fill,
                                      size: 16),
                                  filterValue: 'villa',
                                ),
                                buildFilterChip(
                                  context: context,
                                  label: "Condo",
                                  avatar: Icon(FlutterRemix.building_3_fill,
                                      size: 16),
                                  filterValue: 'condo',
                                ),
                                buildFilterChip(
                                  context: context,
                                  label: "Townhouse",
                                  avatar:
                                      Icon(FlutterRemix.home_4_fill, size: 16),
                                  filterValue: 'townhouse',
                                ),
                                buildFilterChip(
                                  context: context,
                                  label: "Studio",
                                  avatar:
                                      Icon(FlutterRemix.home_5_fill, size: 16),
                                  filterValue: 'studio',
                                ),
                                buildFilterChip(
                                  context: context,
                                  label: "Penthouse",
                                  avatar: Icon(FlutterRemix.building_fill,
                                      size: 16),
                                  filterValue: 'penthouse',
                                ),
                                buildFilterChip(
                                  context: context,
                                  label: "Loft",
                                  avatar: Icon(FlutterRemix.building_line,
                                      size: 16),
                                  filterValue: 'loft',
                                ),
                                buildFilterChip(
                                  context: context,
                                  label: "Hotel",
                                  avatar: Icon(FlutterRemix.building_fill,
                                      size: 16),
                                  filterValue: 'hotel',
                                ),
                                buildFilterChip(
                                  context: context,
                                  label: "Motel",
                                  avatar: Icon(FlutterRemix.building_line,
                                      size: 16),
                                  filterValue: 'motel',
                                ),
                                buildFilterChip(
                                  context: context,
                                  label: "Guesthouse",
                                  avatar: Icon(FlutterRemix.building_fill,
                                      size: 16),
                                  filterValue: 'guesthouse',
                                ),
                                buildFilterChip(
                                  context: context,
                                  label: "Cottage",
                                  avatar: Icon(FlutterRemix.building_line,
                                      size: 16),
                                  filterValue: 'cottage',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          controller.recommendedProperties.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    "Recommended for You",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          controller.recommendedProperties.isNotEmpty
                              ? SizedBox(
                                  height: 280,
                                  child: Obx(() => ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        itemCount: controller
                                            .recommendedProperties.length,
                                        itemBuilder: (context, index) {
                                          final property = controller
                                              .recommendedProperties[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16.0),
                                            child: ListingCard(
                                              property: property,
                                              imageWidth: 220,
                                              imageHeight: 160,
                                              cardHeight: 260,
                                            ),
                                          );
                                        },
                                      )))
                              : const SizedBox.shrink(),

                          const SizedBox(height: 16.0),
                          Text("All Properties",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                              .paddingOnly(left: 16),
                          const SizedBox(height: 8.0),
                          Obx(() => ListView.builder(
                                primary: false,
                                shrinkWrap: true,
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
                                    );
                                  } else {
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
                                },
                              )),
                          // Loading indicator at bottom
                          Obx(() => controller.isLoadingMore.value
                              ? SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Lottie.asset(
                                      'assets/animations/loading_more.json',
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                )
                              : const SizedBox()),

                          // No more data message
                          Obx(() => !controller.isLoadingMore.value &&
                                  !controller.hasMoreData.value
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    "No more properties to load",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : const SizedBox()),

                          // Banner ad at the bottom
                          if (adService.isAdLoaded.value)
                            SizedBox(
                              key: UniqueKey(),
                              width: adService.bannerAd!.size.width.toDouble(),
                              height:
                                  adService.bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: adService.bannerAd!),
                            ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
            ),
          ),
        ));
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
