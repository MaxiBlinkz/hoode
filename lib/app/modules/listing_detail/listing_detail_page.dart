import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'package:hoode/app/core/widgets/avatar.dart';

import 'listing_detail_controller.dart';

class ListingDetailPage extends GetView<ListingDetailController> {
  ListingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final property = Get.arguments;
    final id = property.id;
    final listing = property.data;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ListingDetailPage'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(children: [
        SizedBox(
          height: 300,
          child: Image.network(
            "$POCKETBASE_URL_ANDROID/api/files/properties/$id/${listing['image']}",
            fit: BoxFit.cover,
            height: 300,
            width: double.infinity,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          listing['title'],
          style: TextStyle(fontSize: 20),
        ),
        Text(listing['location']),
        SizedBox(
          height: 400,
          child: ContainedTabBarView(
              tabBarProperties: TabBarProperties(
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary),
              tabs: [
                Text('About'),
                Text('Gallery'),
                Text('Reviews')
              ],
              views: [
                Column(
                  children: [
                    Text('Description'),
                    Text(listing['description']),
                    Text('Listing Agent'),
                    Row(
                      children: [
                        Avatar(
                          initials: "MK",
                          image_url: "assets/images/avatar.jpg",
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.email_outlined)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                      ],
                    )
                  ],
                ),
                Container(
                  height: 200,
                  color: Colors.red,
                ),
                Container(
                  height: 200,
                  color: Colors.green,
                ),
              ]),
        ),
      ])),
    );
  }
}
