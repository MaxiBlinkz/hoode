import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/authservice.dart';
import '../../core/analytics/models/market_analytics.dart';
import '../../data/services/user_service.dart';
import '../../data/services/supabase_service.dart';

class DashboardController extends GetxController {
  // User data
  final user = Rxn<User>();
  final userProfile = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final listingsCount = 0.obs;
  final savedListingsCount = 0.obs;
  final isAgent = false.obs;
  
  // Services
  final userService = Get.find<UserService>();
  final authService = Get.find<AuthService>();
  
  // Analytics data
  final marketPriceTrend = <FlSpot>[].obs;
  final marketDemandTrend = <FlSpot>[].obs;
  final propertyTypeTrends = <String, double>{}.obs;
  final monthlyRevenue = <FlSpot>[].obs;
  
  // Dashboard metrics
  final totalViews = 0.obs;
  final newLeads = 0.obs;
  
  // Active listings
  final activeListings = <Map<String, dynamic>>[].obs;
  
  // Get Supabase client
  SupabaseClient get _client => SupabaseService.to.client;

  @override
  void onInit() {
    super.onInit();
    loadUserDashboard();
  }

  Future<void> loadUserDashboard() async {
    isLoading(true);
    try {
      // Get current user
      user.value = _client.auth.currentUser;
      
      if (user.value != null) {
        // Load user profile
        await _loadUserProfile();
        
        // Check if user is an agent
        isAgent.value = await userService.isUserAgent(user.value!.id);
        
        if (isAgent.value) {
          // Load agent-specific data
          await _loadAgentListings();
          await loadAgentStats();
          
          // Load dashboard metrics
          await _loadDashboardMetrics();
        } else {
          // Load user-specific data (non-agent)
          await _loadUserSavedListings();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      isLoading(false);
    }
  }
  
  Future<void> _loadUserProfile() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', user.value!.id)
          .single();
      
      userProfile.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user profile');
    }
  }

  Future<void> _loadAgentListings() async {
    try {
      // Get total listings count
      final countResponse = await _client
          .from('properties')
          .select('id')
          .eq('agent', user.value!.id)
          .count(CountOption.exact);
      
      listingsCount.value = countResponse.count ?? 0;
      
      // Get active listings (limited to 5)
      final activeListingsResponse = await _client
          .from('properties')
          .select()
          .eq('agent', user.value!.id)
          .eq('status', 'active')
          .order('created_at', ascending: false)
          .limit(5);
      
      activeListings.value = activeListingsResponse;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load listings');
    }
  }
  
  Future<void> _loadUserSavedListings() async {
    try {
      // Get saved listings count
      final savedListingsResponse = await _client
          .from('bookmarks')
          .select('id')
          .eq('user_id', user.value!.id)
          .count(CountOption.exact);
      
      savedListingsCount.value = savedListingsResponse.count ?? 0;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load saved listings');
    }
  }
  
  Future<void> _loadDashboardMetrics() async {
    try {
      // Get total views for agent's properties
      final viewsResponse = await _client.rpc(
        'get_total_property_views',
        params: {'agent_id': user.value!.id}
      );
      
      totalViews.value = viewsResponse ?? 0;
      
      // Get new leads count (messages from new users in the last 30 days)
      final currentDate = DateTime.now();
      final thirtyDaysAgo = currentDate.subtract(const Duration(days: 30));
      
      final leadsResponse = await _client
          .from('conversations')
          .select('id')
          .eq('agent_id', user.value!.id)
          .gte('created_at', thirtyDaysAgo.toIso8601String())
          .count(CountOption.exact);
      
      newLeads.value = leadsResponse.count ?? 0;
    } catch (e) {
      // If we can't load real metrics, use sample data for now
      totalViews.value = 1234;
      newLeads.value = 48;
    }
  }

  Future<void> loadAgentStats() async {
    // Load analytics data
    marketPriceTrend.value = MarketAnalytics.getPriceTrends();
    marketDemandTrend.value = MarketAnalytics.getDemandTrends();
    propertyTypeTrends.value = MarketAnalytics.getPropertyTypeDistribution();
    monthlyRevenue.value = MarketAnalytics.getRevenueData();
    
    // In a real app, we would fetch this data from Supabase
    // For example:
    /*
    try {
      final priceTrendsResponse = await _client
          .from('market_analytics')
          .select('month, price_index')
          .order('month');
      
      marketPriceTrend.value = priceTrendsResponse
          .map((item) => FlSpot(
                item['month'].toDouble(), 
                item['price_index'].toDouble()
              ))
          .toList();
    } catch (e) {
      // Fall back to sample data
      marketPriceTrend.value = MarketAnalytics.getPriceTrends();
    }
    */
  }

  // Navigation methods
  void navigateToMyListings() => Get.toNamed('/my-listings');
  void navigateToAddListing() => Get.toNamed('/add-listing');
  void navigateToMessages() => Get.toNamed('/messages');
  void navigateToAnalytics() => Get.toNamed('/analytics');
  void navigateToBookings() => Get.toNamed('/bookings');
  void navigateToSettings() => Get.toNamed('/settings');

  Future<void> becomeAgent() async {
    try {
      isLoading(true);
      
      // Update user profile to mark as agent
      await _client
          .from('users')
          .update({ 'is_agent': true })
          .eq('id', user.value!.id);
      
      // Create agent profile entry
      await _client
          .from('agent_profiles')
          .insert({
            'user_id': user.value!.id,
            'bio': '',
            'experience_years': 0,
            'specialization': '',
            'created_at': DateTime.now().toIso8601String()
          });
      
      // Refresh user data
      isAgent(true);
      Get.snackbar('Success', 'You are now an agent!');
      
      // Reload dashboard data
      await loadUserDashboard();
    } catch (e) {
      Get.snackbar('Error', 'Failed to become an agent. Please try again.');
    } finally {
      isLoading(false);
    }
  }
  
  // Helper method to refresh dashboard data
  Future<void> refreshDashboard() async {
    isLoading(true);
    await loadUserDashboard();
    isLoading(false);
  }
}
