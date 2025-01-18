import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../core/config/constants.dart';
import '../../data/models/marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../data/enums/enums.dart';

class MapViewController extends GetxController {

  var status = Status.initial.obs;
  final pb = PocketBase(POCKETBASE_URL);

  Stream<List<Marker>> getPropertyMarkers(int page) async* {
  status(Status.loading);
  
  final response = await pb.collection('properties').getList(
    page: page,
    perPage: 20,
    sort: 'longitude,latitude',
  );

  final markers = response.items.map((property) => Marker(
    point: LatLng(
      property.data['latitude'], 
      property.data['longitude']
    ),
    width: 60,
    height: 60,
    child: GestureDetector(
      onTap: () {
        // Handle marker tap - e.g. show property details
      },
      child: Icon(Icons.location_city),
    )
  )).toList();

  status(Status.success);
  yield markers;
}


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
