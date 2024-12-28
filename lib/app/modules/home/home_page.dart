import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
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
import 'package:flutter_remix/flutter_remix.dart';
// import 'package:hoode/app/data/enums/enums.dart';

//import '../../../gen/assets.gen.dart';
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
        backgroundColor: Colors.white,
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
          child: SingleChildScrollView(
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text("House"),
                          avatar: Icon(IconlyBold.home, size: 16),
                          selected: false,
                          onSelected: null,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text("Apartment"),
                          avatar: Icon(IconlyBold.home, size: 16),
                          selected: false,
                          onSelected: null,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text("Villa"),
                          avatar: Icon(FlutterRemix.building_2_fill, size: 16),
                          selected: false,
                          onSelected: null,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text("House"),
                          avatar: Icon(FlutterRemix.building_fill, size: 16),
                          selected: false,
                          onSelected: null,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text("Apartment"),
                          avatar: Icon(EvaIcons.home_outline, size: 16),
                          selected: false,
                          onSelected: null,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text("Villa"),
                          avatar: Icon(EvaIcons.award, size: 16),
                          selected: false,
                          onSelected: null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                controller.recommendedProperties.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Recommended for You",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    : const SizedBox.shrink(),
                controller.recommendedProperties.isNotEmpty
                    ? SizedBox(
                        height: 280,
                        child: Obx(() => ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              itemCount:
                                  controller.recommendedProperties.length,
                              itemBuilder: (context, index) {
                                final property =
                                    controller.recommendedProperties[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
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
                            fontSize: 18, fontWeight: FontWeight.bold))
                    .paddingOnly(left: 16),
                const SizedBox(height: 8.0),
                Obx(
                  () => ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: controller.properties.length +
                        (controller.isLoadingMore.value ? 3 : 0),
                    itemBuilder: (context, index) {
                      if (index < controller.properties.length) {
                        final property = controller.properties[index];
                        return ListingCard(
                          property: property,
                          imageWidth: double.infinity,
                          imageHeight: 180,
                          cardHeight: 300,
                        );
                      } else {
                        // Show skeleton only for new loading items
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
                  ),
                ),
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
                    height: adService.bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: adService.bannerAd!),
                  ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
