import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'map_view_controller.dart';

class MapViewPage extends GetView<MapViewController> {
  const MapViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(51.509364, -0.128928),
          initialZoom: 9.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.hoode.app',
          ),
        ],
      ),
    );
  }
}
