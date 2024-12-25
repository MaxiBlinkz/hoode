import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class DashboardController extends GetxController {
  final user = Rxn<RecordModel>();
  final isLoading = false.obs;
  final listingsCount = 0.obs;
  final savedListingsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserDashboard();
  }

  Future<void> loadUserDashboard() async {
    isLoading.value = true;
    try {
      // Load user dashboard data
      // Load listings count
      // Load saved listings count
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToMyListings() {
    Get.toNamed('/my-listings');
  }

  void navigateToAddListing() {
    Get.toNamed('/add-listing');
  }

  void navigateToSettings() {
    Get.toNamed('/settings');
  }
}
