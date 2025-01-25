import 'package:get/get.dart';
import 'package:logger/logger.dart';


class AnalyticsController extends GetxController {
  final totalProperties = 0.obs;
  final totalViews = 0.obs;
  final totalRevenue = 0.0.obs;
   final isLoading = true.obs;
   final logger = Logger();


  @override
  void onInit() {
    super.onInit();
    loadAnalyticsData();
  }

  Future<void> loadAnalyticsData() async {
    isLoading.value = true;
     try{
        // Simulate analytics data
        totalProperties.value = 50;
        totalViews.value = 1500;
        totalRevenue.value = 75000.00;
     }catch(e){
      logger.e("Error fetching analytics: $e");
     }finally{
       isLoading.value = false;
     }
  }
}