import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/services/authservice.dart';
import '../../core/analytics/models/market_analytics.dart';
import '../../data/services/db_helper.dart';
import '../../data/services/user_service.dart';
import 'package:pocketbase/pocketbase.dart';

class DashboardController extends GetxController {
  final user = Rxn<RecordModel>();
  final isLoading = false.obs;
  final listingsCount = 0.obs;
  final savedListingsCount = 0.obs;
  final isAgent = false.obs;
  final userService = Get.find<UserService>();
  final authService = Get.find<AuthService>();
  final pb = PocketBase(DbHelper.getPocketbaseUrl());

  final marketPriceTrend = <FlSpot>[].obs;
  final marketDemandTrend = <FlSpot>[].obs;
  final propertyTypeTrends = <String, double>{}.obs;
  final monthlyRevenue = <FlSpot>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserDashboard();
  }

  Future<void> loadUserDashboard() async {
  isLoading(true);
  try {
    user.value = authService.getCurrentUser() as RecordModel?;
    if (user.value != null) {
      isAgent.value = await userService.isUserAgent(user.value!.id);
      
      if (isAgent.value) {
        final records = await pb.collection('properties').getList(
          filter: 'agent = "${user.value!.id}"',
        );
        listingsCount.value = records.totalItems;
        
        await loadAgentStats();
      }
    }
  } finally {
    isLoading(false);
  }
}


  Future<void> loadAgentStats() async {
    // Load messages count, bookings, etc.
    marketPriceTrend.value = MarketAnalytics.getPriceTrends();
    marketDemandTrend.value = MarketAnalytics.getDemandTrends();
    propertyTypeTrends.value = MarketAnalytics.getPropertyTypeDistribution();
    monthlyRevenue.value = MarketAnalytics.getRevenueData();
  }

  void navigateToMyListings() => Get.toNamed('/my-listings');
  void navigateToAddListing() => Get.toNamed('/add-listing');
  void navigateToMessages() => Get.toNamed('/messages');
  void navigateToAnalytics() => Get.toNamed('/analytics');
  void navigateToBookings() => Get.toNamed('/bookings');
  void navigateToSettings() => Get.toNamed('/settings');

  Future<void> becomeAgent() async {
    Get.toNamed('/become-agent');
  }
}
