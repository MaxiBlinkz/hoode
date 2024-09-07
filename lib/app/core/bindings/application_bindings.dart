import 'package:get/get.dart';
// import 'package:hoode/app/data/services/api_service.dart';
// import 'package:dio/dio.dart';

class ApplicationBindings extends Bindings {
  @override
  void dependencies() {
   // Get.lazyPut(() => ApiClient(Dio(BaseOptions(contentType: "application/json"))));
  }
}
