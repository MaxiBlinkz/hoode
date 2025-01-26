import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/services/authservice.dart';
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
  late final PocketBase pb;

  final marketPriceTrend = <FlSpot>[].obs;
  final marketDemandTrend = <FlSpot>[].obs;
  final propertyTypeTrends = <String, double>{}.obs;
  final monthlyRevenue = <FlSpot>[].obs;


  // New variables for the dashboard
  final totalViews = 0.obs; // added totalViews
  final newLeads = 0.obs;  // added newLeads


    final activeListings = <RecordModel>[].obs; // Active listings

  @override
  void onInit() async{
    super.onInit();
    String url = await DbHelper.getPocketbaseUrl();
    pb = PocketBase(url);
    loadUserDashboard();
  }

  Future<RecordModel?> getCurrentUser() async {
    if (!pb.authStore.isValid || pb.authStore.record == null) {
      final token = GetStorage().read('authToken');
      final userData = GetStorage().read('userData');

      if (token != null && userData != null) {
        pb.authStore.save(token, RecordModel.fromJson(userData));
        await pb.collection('users').authRefresh();

        if (!pb.authStore.isValid) {
          Get.toNamed('/login');
          return null;
        }
      }
    }
    return pb.authStore.record;
  }

  Future<void> loadUserDashboard() async {
    isLoading(true);
    try {
      user.value = await getCurrentUser();
      if (user.value != null) {
        isAgent.value = await userService.isUserAgent(user.value!.id);

        if (isAgent.value) {
          final records = await pb.collection('properties').getList(
            filter: 'agent = "${user.value!.id}"',
          );
            // Fetch active listings
           final activeListingsResponse = await pb.collection('properties').getList(
                filter: 'agent = "${user.value!.id}"',
                perPage: 5,
            );
            activeListings.value = activeListingsResponse.items;

          listingsCount.value = records.totalItems;
           // Simulate data for total views
           totalViews.value = 1234;
           // Simulate data for new leads
            newLeads.value = 48;

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