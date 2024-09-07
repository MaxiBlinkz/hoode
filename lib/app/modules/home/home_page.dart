import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:hoode/app/data/models/property.dart';
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
  final _future = Supabase.instance.client.from('properties').select();

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    bool isPropertyEmpty = true;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Avatar(
          initials: "MK",
          image_url: "assets/images/avatar.jpg",
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              height: 40,
              width: 280,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
            )),
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: Colors.white,
            ),
            iconSize: 24.0,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              FlutterRemix.compass_discover_fill,
              color: Colors.white,
            ),
            iconSize: 24.0,
            onPressed: () {},
          ),
          IconButton(
            //alignment: Alignment.centerRight,
            //padding: const EdgeInsets.all(0),
            icon: const Icon(
              FlutterRemix.notification_2_fill,
              color: Colors.white,
            ),
            iconSize: 20.0,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          // AppBar
          //Header(),
          const SizedBox(height: 8.0),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: () {
                    return controller.fetchProperties();
                  },
                  child: ListView(
                    children: [
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: 80,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildCategoryItem(
                                  "House", FlutterRemix.home_3_fill),
                              _buildCategoryItem(
                                  "Apartment", FlutterRemix.building_4_fill),
                              _buildCategoryItem(
                                  "Villa", FlutterRemix.building_2_fill),
                              _buildCategoryItem(
                                  "House", FlutterRemix.building_fill),
                              _buildCategoryItem(
                                  "Apartment", EvaIcons.home_outline),
                              _buildCategoryItem("Villa", EvaIcons.award),
                              _buildCategoryItem("House", EvaIcons.home),
                              _buildCategoryItem(
                                  "Apartment", EvaIcons.home_outline),
                              _buildCategoryItem("Villa", EvaIcons.award),
                            ]),
                      ),
                      const SizedBox(height: 4.0),
                      SizedBox(
                          height: 250,
                          child: isPropertyEmpty
                              ? null
                              : FutureBuilder(
                                  future: _future,
                                  builder: (context, snapshot) {
                                    final properties = snapshot.data!;
                                    return CarouselView(
                                        itemExtent: 260,
                                        itemSnapping: true,
                                        children:
                                            List.generate(20, (int index) {
                                          final property = properties[index];
                                          return ListingCard(
                                            title: property['title'],
                                            property_id: property['id'],
                                            price: property['price'],
                                            location: property['location'],
                                            status: property['status'],
                                            image_url: property['image_url'],
                                          );
                                        }));
                                  })),
                      Skeletonizer(
                        enabled: isPropertyEmpty,
                        ignoreContainers: true,
                        child: FutureBuilder(
                            future: _future,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                isPropertyEmpty = true;
                                return GridView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.82),
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return ListingCard(
                                        title: BoneMock.fullName,
                                        property_id: BoneMock.name,
                                        price: 200,
                                        location: BoneMock.city,
                                        status: BoneMock.name,
                                        image_url: "house1.jpg",
                                      );
                                    });
                              } else {
                                final properties = snapshot.data!;
                                return GridView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.82),
                                    itemCount: properties.length,
                                    itemBuilder: (context, index) {
                                      final property = properties[index];
                                      print(property['title']);
                                      return ListingCard(
                                        title: property['title'],
                                        property_id: property['id'],
                                        price: property['price'],
                                        location: property['location'],
                                        status: property['status'],
                                        image_url: property['image_url'],
                                      );
                                    });
                              }
                            }),
                      )
                      //}),
                    ],
                  )))
        ]),
      ),

      //}),
      //),
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
}
