import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../data/services/authservice.dart';
import '../../data/services/supabase_service.dart';
import 'package:logger/logger.dart';

class BookingsController extends GetxController with GetTickerProviderStateMixin {
  // Services
  final authService = Get.find<AuthService>();
  final logger = Logger();
  
  // Supabase client
  SupabaseClient get _client => SupabaseService.to.client;
  
  // State variables
  final bookings = <Map<String, dynamic>>[].obs;
  final filteredBookings = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final selectedFilter = 'all'.obs;
  final selectedDate = Rxn<DateTime>();
  final isRefreshing = false.obs;
  
  // Tabs
  late TabController tabController;
  final tabs = ['Upcoming', 'Past', 'Cancelled'];
  
  // Search
  final searchQuery = ''.obs;
  final searchController = TextEditingController();
  
  // Pagination
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final pageSize = 10;
  final hasMoreData = true.obs;
  
  // Sorting
  final sortBy = 'date'.obs;
  final sortAscending = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabChange);
    loadBookings();
    
    // Listen for search query changes
    debounce(
      searchQuery,
      (_) => _filterBookings(),
      time: const Duration(milliseconds: 500),
    );
  }
  
  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      switch (tabController.index) {
        case 0:
          selectedFilter.value = 'upcoming';
          break;
        case 1:
          selectedFilter.value = 'past';
          break;
        case 2:
          selectedFilter.value = 'cancelled';
          break;
      }
      _filterBookings();
    }
  }
  
  Future<void> loadBookings() async {
    try {
      isLoading(true);
      hasError(false);
      
      final currentUser = authService.user.value;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      
      // Query bookings from Supabase
      final response = await _client
          .from('bookings')
          .select('*, properties(*), users!bookings_agent_id_fkey(*)')
          .or('user_id.eq.${currentUser.id},agent_id.eq.${currentUser.id}')
          .order('date', ascending: false);
      
      // Transform response to include computed properties
      final transformedBookings = response.map((booking) {
        // Parse date and time for easier filtering
        final bookingDate = DateTime.parse(booking['date']);
        final now = DateTime.now();
        
        // Determine if booking is upcoming, past, or cancelled
        String status = booking['status'] ?? 'pending';
        String timeframe = 'upcoming';
        
        if (status.toLowerCase() == 'cancelled') {
          timeframe = 'cancelled';
        } else if (bookingDate.isBefore(DateTime(now.year, now.month, now.day))) {
          timeframe = 'past';
        }
        
        // Format date and time for display
        final formattedDate = DateFormat('MMM dd, yyyy').format(bookingDate);
        final formattedTime = booking['time'] ?? 'N/A';
        
        // Get property and agent details
        final property = booking['properties'] ?? {};
        final agent = booking['users'] ?? {};
        
        return {
          ...booking,
          'timeframe': timeframe,
          'formatted_date': formattedDate,
          'formatted_time': formattedTime,
          'property_title': property['title'] ?? 'Unknown Property',
          'property_address': property['location'] ?? 'No Address',
          'property_image': property['image'] != null && property['image'].isNotEmpty 
              ? property['image'][0] 
              : null,
          'agent_name': agent['full_name'] ?? 'Unknown Agent',
          'agent_avatar': agent['avatar_url'],
          'is_agent': currentUser.id == booking['agent_id'],
          'is_user': currentUser.id == booking['user_id'],
        };
      }).toList();
      
      bookings.value = transformedBookings;
      _filterBookings();
      
    } catch (e) {
      hasError(true);
      errorMessage.value = 'Failed to load bookings: ${e.toString()}';
      logger.e('Error loading bookings: $e');
    } finally {
      isLoading(false);
    }
  }
  
  Future<void> refreshBookings() async {
    isRefreshing(true);
    await loadBookings();
    isRefreshing(false);
  }
  
  void _filterBookings() {
    if (bookings.isEmpty) {
      filteredBookings.clear();
      return;
    }
    
    var result = List<Map<String, dynamic>>.from(bookings);
    
    // Filter by tab/timeframe
    if (selectedFilter.value != 'all') {
      result = result.where((booking) => 
        booking['timeframe'] == selectedFilter.value
      ).toList();
    }
    
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((booking) => 
        booking['property_title'].toString().toLowerCase().contains(query) ||
        booking['property_address'].toString().toLowerCase().contains(query) ||
        booking['agent_name'].toString().toLowerCase().contains(query) ||
        booking['formatted_date'].toString().toLowerCase().contains(query)
      ).toList();
    }
    
    // Filter by selected date
    if (selectedDate.value != null) {
      final selectedDateStr = DateFormat('MMM dd, yyyy').format(selectedDate.value!);
      result = result.where((booking) => 
        booking['formatted_date'] == selectedDateStr
      ).toList();
    }
    
    // Sort results
    result.sort((a, b) {
      if (sortBy.value == 'date') {
        final aDate = DateTime.parse(a['date']);
        final bDate = DateTime.parse(b['date']);
        return sortAscending.value 
            ? aDate.compareTo(bDate) 
            : bDate.compareTo(aDate);
      } else if (sortBy.value == 'status') {
        return sortAscending.value 
            ? a['status'].compareTo(b['status']) 
            : b['status'].compareTo(a['status']);
      }
      return 0;
    });
    
    filteredBookings.value = result;
    
    // Update pagination
    totalPages.value = (filteredBookings.length / pageSize).ceil();
    hasMoreData.value = currentPage.value < totalPages.value;
  }
  
  void setFilter(String filter) {
    selectedFilter.value = filter;
    _filterBookings();
  }
  
  void setDate(DateTime? date) {
    selectedDate.value = date;
    _filterBookings();
  }
  
  void clearFilters() {
    selectedFilter.value = 'all';
    selectedDate.value = null;
    searchQuery.value = '';
    searchController.clear();
    tabController.index = 0;
    _filterBookings();
  }
  
  void setSorting(String field) {
    if (sortBy.value == field) {
      sortAscending.toggle();
    } else {
      sortBy.value = field;
      sortAscending.value = true;
    }
    _filterBookings();
  }
  
  void search(String query) {
    searchQuery.value = query;
  }
  
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _client
          .from('bookings')
          .update({'status': 'Cancelled'})
          .eq('id', bookingId);
      
      // Update local state
      final index = bookings.indexWhere((booking) => booking['id'] == bookingId);
      if (index != -1) {
        bookings[index]['status'] = 'Cancelled';
        bookings[index]['timeframe'] = 'cancelled';
        bookings.refresh();
        _filterBookings();
      }
      
      Get.snackbar(
        'Booking Cancelled',
        'Your booking has been cancelled successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      logger.e('Error cancelling booking: $e');
      Get.snackbar(
        'Error',
        'Failed to cancel booking: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  Future<void> confirmBooking(String bookingId) async {
    try {
      await _client
          .from('bookings')
          .update({'status': 'Confirmed'})
          .eq('id', bookingId);
      
      // Update local state
      final index = bookings.indexWhere((booking) => booking['id'] == bookingId);
      if (index != -1) {
        bookings[index]['status'] = 'Confirmed';
        bookings.refresh();
        _filterBookings();
      }
      
      Get.snackbar(
        'Booking Confirmed',
        'The booking has been confirmed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      logger.e('Error confirming booking: $e');
      Get.snackbar(
        'Error',
        'Failed to confirm booking: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  Future<void> rescheduleBooking(String bookingId, DateTime newDate, String newTime) async {
    try {
      await _client
          .from('bookings')
          .update({
            'date': newDate.toIso8601String(),
            'time': newTime,
            'status': 'Rescheduled'
          })
          .eq('id', bookingId);
      
      // Update local state and refresh
      await loadBookings();
      
      Get.snackbar(
        'Booking Rescheduled',
        'Your booking has been rescheduled successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      logger.e('Error rescheduling booking: $e');
      Get.snackbar(
        'Error',
        'Failed to reschedule booking: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  void showRescheduleDialog(BuildContext context, Map<String, dynamic> booking) {
    final initialDate = DateTime.parse(booking['date']);
    final selectedDate = Rx<DateTime>(initialDate);
    final selectedTime = RxString(booking['time'] ?? '10:00 AM');
    
    Get.dialog(
      AlertDialog(
        title: const Text('Reschedule Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select a new date and time:'),
            const SizedBox(height: 16),
            
            // Date picker
            Obx(() => OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                DateFormat('MMM dd, yyyy').format(selectedDate.value),
              ),
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  selectedDate.value = pickedDate;
                }
              },
            )),
            
            const SizedBox(height: 16),
            
            // Time picker
            DropdownButtonFormField<String>(
              value: selectedTime.value,
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
              items: [
                '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
                '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM'
              ].map((time) => DropdownMenuItem(
                value: time,
                child: Text(time),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedTime.value = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              rescheduleBooking(
                booking['id'],
                selectedDate.value,
                selectedTime.value,
              );
            },
            child: const Text('Reschedule'),
          ),
        ],
      ),
    );
  }
  
  void navigateToBookingDetails(Map<String, dynamic> booking) {
    Get.toNamed('/booking-details', arguments: booking);
  }
  
  void navigateToPropertyDetails(Map<String, dynamic> booking) {
    Get.toNamed('/listing-detail', arguments: booking['property_id']);
  }
  
  void contactAgent(Map<String, dynamic> booking) {
    // Navigate to chat with the agent
    Get.toNamed('/chat-view', arguments: {
      'agent': booking['agent_id'],
      'property_id': booking['property_id'],
    });
  }
  
  @override
  void onClose() {
    tabController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
