import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'listing_search_controller.dart';

class ListingSearchPage extends GetView<ListingSearchController> {
  const ListingSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListingSearchPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ListingSearchPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
