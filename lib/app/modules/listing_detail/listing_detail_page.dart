import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'listing_detail_controller.dart';

class ListingDetailPage extends GetView<ListingDetailController> {
  const ListingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListingDetailPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ListingDetailPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
