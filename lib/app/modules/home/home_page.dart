import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hoode/app/core/widgets/category_item.dart';
import 'package:hoode/app/data/services/adservice.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
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
        flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 62,
                width: 340,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(24)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Search",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 18))
                      .paddingOnly(left: 8),
                )).paddingOnly(bottom: 8, left: 4)),
        actions: [
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
              child: RefreshIndicator(onRefresh: () {
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
                                  title: "Apartment",
                                icon: IconlyBold.home),
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
                                return snapshot.hasData
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          final featuredProperty =
                                              snapshot.hasData
                                                  ? snapshot.data![index]
                                                  : null;
                                          return ListingCard(
                                            property: featuredProperty,
                                          );
                                        })
                                    : const Center(
                                        child: CircularProgressIndicator());
                              })),
                      const SizedBox(height: 16.0),
                      Text("All Properties",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))
                          .paddingOnly(left: 16),

                      // ################## All Properties ########################
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          itemCount:
                              snapshot.hasData ? snapshot.data!.length : 5,
                          itemBuilder: (context, index) {
                            final property =
                                snapshot.hasData ? snapshot.data![index] : null;
                            return ListingCard(
                              property: property,
                            );
                          }),
                
                      // ################## Banner ad at bottom #######################
                      Obx(() => controller.isLoading.value
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
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
