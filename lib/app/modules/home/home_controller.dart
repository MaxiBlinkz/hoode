//import 'dart:convert';

//import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/models/property.dart';
import 'package:hoode/app/data/services/api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final RxList<Property> properties = <Property>[].obs;
  final RxList<Property> featuredList = <Property>[].obs;
  var isPropertyListEmpty = true.obs;

  // final apiClient = Get.find<ApiClient>();

  // Future<void> getProperties() async {
  //   isPropertyListEmpty.value = true;
  //   try {
  //     final propertyList = await apiClient.getProperties();
  //     properties.assignAll(propertyList);
  //   } catch (e) {
  //     print("Get Properties returned an error: $e");
  //   }
  // }

  Future fetchProperties() async {
    var response = await Supabase.instance.client.from('properties').select();

    return response;
  }

  @override
  void onInit() async {
    super.onInit();
    //await getProperties();
  }
}
