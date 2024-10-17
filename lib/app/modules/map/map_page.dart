import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'map_controller.dart';

class MapPage extends GetView<MapController> {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MapPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MapPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
