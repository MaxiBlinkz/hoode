import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/widgets/category_item.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_remix/flutter_remix.dart';

//import '../../../gen/assets.gen.dart';
import '../../core/theme/colors.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/listing_card.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    // bool isPropertyEmpty = true;

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
                height: 42,
                width: 250,
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
          IconButton(
            icon: const Icon(
              IconlyLight.notification,
              color: AppColors.primary,
            ),
            iconSize: 20.0,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          const SizedBox(height: 8.0),
          Expanded(
              child: RefreshIndicator(onRefresh: () {
            return controller.getProperties();
          }, child: Obx(() {
            return ListView(
              children: [
                const SizedBox(height: 8.0),
                SizedBox(
                  height: 80,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        CategoryItem(
                            title: "House", icon: FlutterRemix.home_3_fill),
                        CategoryItem(
                            title: "Apartment",
                            icon: FlutterRemix.building_4_fill),
                        CategoryItem(
                            title: "Villa", icon: FlutterRemix.building_2_fill),
                        CategoryItem(
                            title: "House", icon: FlutterRemix.building_fill),
                        CategoryItem(
                            title: "Apartment", icon: EvaIcons.home_outline),
                        CategoryItem(title: "Villa", icon: EvaIcons.award),
                        CategoryItem(title: "House", icon: EvaIcons.home),
                        CategoryItem(
                            title: "Apartment", icon: EvaIcons.home_outline),
                        CategoryItem(title: "Villa", icon: EvaIcons.award),
                      ]),
                ),
                const SizedBox(height: 4.0),
                SizedBox(
                    height: controller.isLoading.value ? null : 250,
                    child: controller.isLoading.value
                        ? null
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.properties.length,
                            itemBuilder: (context, index) {
                              final property = controller.properties[index];
                              return ListingCard(
                                property: property,
                              );
                            })),
                Skeletonizer(
                  enabled: controller.isLoading.value,
                  ignoreContainers: true,
                  child: GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      controller: controller.listController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.82),
                      itemCount: controller.properties.length,
                      itemBuilder: (context, index) {
                        final property = controller.properties[index];
                        return ListingCard(
                          property: property,
                        );
                      }),
                )
              ],
            );
          })))
        ]),
      ),
    );
  }
}
