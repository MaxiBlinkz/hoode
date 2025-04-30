import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './supabase_service.dart';

class BookmarkService extends GetxService {
  final bookmarks = <String>[].obs;
  
  // Get Supabase client
  SupabaseClient get _client => SupabaseService.to.client;
  
  @override
  void onInit() {
    super.onInit();
    loadBookmarks();

    // Set up realtime subscription for bookmarks
    _setupRealtimeSubscription();
  }
  
  void _setupRealtimeSubscription() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
  
    final myChannel = _client.channel('my_bookmarks_channel');

    myChannel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bookmarks',
          // Use the correct filter format
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            // Reload bookmarks when changes occur
            loadBookmarks();
          },
        )
        .subscribe();
  }


  
  Future<void> loadBookmarks() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      bookmarks.clear();
      return;
    }
    
    try {
      final result = await _client
          .from('bookmarks')
          .select('property_id')
          .eq('user_id', userId);
      
      final propertyIds =
          result.map((item) => item['property_id'] as String).toList();
      bookmarks.assignAll(propertyIds);
    } catch (e) {
      print('Error loading bookmarks: $e');
    }
  }
  
  Future<void> toggleBookmark(String propertyId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      Get.toNamed('/login');
      return;
    }
    
    try {
      if (bookmarks.contains(propertyId)) {
        // Remove bookmark
        await _client
            .from('bookmarks')
            .delete()
            .eq('user_id', userId)
            .eq('property_id', propertyId);
        
        bookmarks.remove(propertyId);
      } else {
        // Add bookmark
        await _client.from('bookmarks').insert({
          'user_id': userId,
          'property_id': propertyId,
        });
        
        bookmarks.add(propertyId);
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
    }
  }
  
  Future<bool> isBookmarked(String propertyId) async {
    return bookmarks.contains(propertyId);
  }
  
  Future<List<Map<String, dynamic>>> getBookmarkedListings() async {
    if (bookmarks.isEmpty) {
      return [];
    }
    
    try {
      final properties =
          await _client.from('properties').select('*').eq('id', bookmarks);
      
      return properties;
    } catch (e) {
      print('Error getting bookmarked listings: $e');
      return [];
    }
  }
}
