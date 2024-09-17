import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:hoode/app/data/models/property.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_remix/flutter_remix.dart';

//import '../../../gen/assets.gen.dart';
import '../../core/theme/colors.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/listing_card.dart';
//import '../../core/widgets/header.dart';
//import '../../core/widgets/featured_card.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  Widget _buildCategoryItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              color: Colors.grey[200],
            ),
            child: Center(
              child: Icon(
                icon,
                size: 24,
                color: AppColors.primary,
              ),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 12.0,
            ),
          )
        ],
      ),
    );
  }

  // final _future = Supabase.instance.client.from('properties').select();

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    // bool isPropertyEmpty = true;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Avatar(
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
              FlutterRemix.notification_2_fill,
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
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    _buildCategoryItem("House", FlutterRemix.home_3_fill),
                    _buildCategoryItem(
                        "Apartment", FlutterRemix.building_4_fill),
                    _buildCategoryItem("Villa", FlutterRemix.building_2_fill),
                    _buildCategoryItem("House", FlutterRemix.building_fill),
                    _buildCategoryItem("Apartment", EvaIcons.home_outline),
                    _buildCategoryItem("Villa", EvaIcons.award),
                    _buildCategoryItem("House", EvaIcons.home),
                    _buildCategoryItem("Apartment", EvaIcons.home_outline),
                    _buildCategoryItem("Villa", EvaIcons.award),
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
                                title: property['title'],
                                id: property['id'],
                                price: property['price'],
                                location: property['location'],
                                status: property['status'],
                                image_url: property['image_url'],
                                description: property['description']
                              );
                            })),
                Skeletonizer(
                  enabled: controller.isLoading.value,
                  ignoreContainers: true,
                  child: GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.82),
                      itemCount: controller.properties.length,
                      itemBuilder: (context, index) {
                        final property = controller.properties[index];
                        return ListingCard(
                          title: property['title'],
                          id: property['id'],
                          price: property['price'],
                          location: property['location'],
                          status: property['status'],
                          image_url: property['image_url'],
                          description: property['description']
                        );
                      }),
                )
              ],
            );
          })))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          child: const Icon(FlutterRemix.map_2_line),
          onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: "Explore"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.black,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            _selectedIndex = index;
          }),
    );
  }
}
