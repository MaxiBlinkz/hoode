import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hoode/app/core/widgets/category_item.dart';
import 'package:hoode/app/core/widgets/listing_card_placeholder.dart';
import 'package:hoode/app/data/services/adservice.dart';
import 'package:hoode/app/modules/listing_search/listing_search_page.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:pocketbase/pocketbase.dart';
// import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:hoode/app/data/enums/enums.dart';

//import '../../../gen/assets.gen.dart';
import '../../core/theme/colors.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/listing_card.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  final adService = AdService.to;

  // TODO fix problem with scrolling up in homepage

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
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          const SizedBox(height: 8.0),
          Expanded(
              child: RefreshIndicator(
            onRefresh: () {
              return controller.loadProperties();
            },
            child: StreamBuilder(
                stream: controller.properties.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Lottie.asset(
                              'assets/lottie/house_loading.json',
                              width: 350,
                              height: 350,
                            )));
                  }
                  return ListView(
                    controller: controller.listController,
                    children: [
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: 80,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              CategoryItem(
                                  title: "House", icon: IconlyBold.home),
                              CategoryItem(
                                  title: "Apartment", icon: IconlyBold.home),
                              CategoryItem(
                                  title: "Villa",
                                  icon: FlutterRemix.building_2_fill),
                              CategoryItem(
                                  title: "House",
                                  icon: FlutterRemix.building_fill),
                              CategoryItem(
                                  title: "Apartment",
                                  icon: EvaIcons.home_outline),
                              CategoryItem(
                                  title: "Villa", icon: EvaIcons.award),
                              CategoryItem(title: "House", icon: EvaIcons.home),
                              CategoryItem(
                                  title: "Apartment",
                                  icon: EvaIcons.home_outline),
                              CategoryItem(
                                  title: "Villa", icon: EvaIcons.award),
                            ]),
                      ),
                      const SizedBox(height: 4.0),
                      Text("Featured Properties",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))
                          .paddingOnly(left: 16),
                      const SizedBox(height: 8.0),

                      // ################## Featured Properties ########################
                      SizedBox(
                          height: 250,
                          child: StreamBuilder(
                              stream: controller.getFeaturedProperties(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        3, // Show placeholders while loading
                                    itemBuilder: (context, index) =>
                                        ListingCardPlaceholder(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                      child: Text(
                                          'No featured properties found.'));
                                } else {
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                        final property = snapshot.data![
                                            index]; // Explicitly type as RecordModel
                                        return ListingCard(
                                            property:
                                                property); // Pass RecordModel to ListingCard
                                      });
                                }
                              })),
                      const SizedBox(height: 16.0),
                      Text("All Properties",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))
                          .paddingOnly(left: 16),

                      // ################## All Properties ########################
ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.hasData
                            ? snapshot.data!.length +
                                (controller.hasMoreData.value ? 1 : 0)
                            : 0,
                        itemBuilder: (context, index) {
                          if (snapshot.hasData &&
                              index < snapshot.data!.length) {
                            // Check if we're within data bounds
                            final property = snapshot.data![index];
                            return ListingCard(
                              property: property,
                              imageWidth: double.infinity,
                              imageHeight: 200,
                              cardHeight: 300,
                            );
                          } else if (controller.hasMoreData.value) {
                            // Show a loading indicator in the last item if there is more data
                            return LoadingAnimationWidget.waveDots(
                              color: Colors.white,
                              size: 20,
                            );
                          } else {
                            // Return an empty container if there's no more data
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      // ################## Banner ad at bottom #######################
                      Obx(() => controller.isLoading.value
                          ? const SizedBox.shrink()
                          : controller.hasMoreData.value
                              ? const SizedBox()
                              : const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    "No more properties to load",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )),

                      // ################## BannerAd at bottom ########################
                      const SizedBox(height: 5),
                      adService.bannerAd != null
                          ? SizedBox(
                              width: adService.bannerAd!.size.width.toDouble(),
                              height:
                                  adService.bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: adService.bannerAd!),
                            )
                          : const SizedBox(),
                    ],
                  );
                }),
          )),
        ]),
      ),
    );
  }
}
