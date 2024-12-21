import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'map_view_controller.dart';

class MapViewPage extends GetView<MapViewController> {
  const MapViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    MapController _mapController = MapController();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Map View'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<Marker>>(
            stream: controller.getPropertyMarkers(1),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(0.55, 0.55),
                    initialZoom: 16,
                  ),
                  children: [
                    TileLayer(
                        // Tile layer options
                        ),
                    MarkerLayer(
                      markers: snapshot.data!,
                    ),
                  ],
                );
              }
              return CircularProgressIndicator();
            }));
  }
}
