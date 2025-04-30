import 'package:get/get.dart';
import '../home/home_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/supabase_service.dart';

class BookmarksController extends GetxController {
  static BookmarksController get to => Get.find();
  
  final supabaseService = SupabaseService.to;
  final bookmarkedListings = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  // Get Supabase client
  SupabaseClient get _client => supabaseService.client;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
    // We'll implement a different approach for listening to bookmark changes
    ever(bookmarkedListings, (_) => Get.find<HomeController>().refreshAfterBookmarkChange());
  }

  Future<void> loadBookmarks() async {
    isLoading(true);
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        bookmarkedListings.clear();
        return;
      }
      
      // Get all bookmarks for the current user
      final bookmarks = await _client
          .from('bookmarks')
          .select('property_id')
          .eq('user_id', userId);
      
      if (bookmarks.isEmpty) {
        bookmarkedListings.clear();
        return;
      }
      
      // Extract property IDs from bookmarks
      final propertyIds = bookmarks.map((bookmark) => bookmark['property_id']).toList();
      
      // Get property details for all bookmarked properties
      final properties = await _client
          .from('properties')
          .select('*')
          .eq('id', propertyIds);
      
      bookmarkedListings.assignAll(properties);
    } catch (e) {
      print('Error loading bookmarks: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeBookmark(String listingId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    
    try {
      // Delete the bookmark
      await _client
          .from('bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('property_id', listingId);
      
      // Update the UI
      bookmarkedListings.removeWhere((listing) => listing['id'] == listingId);
      Get.find<HomeController>().refreshAfterBookmarkChange();
    } catch (e) {
      print('Error removing bookmark: $e');
    }
  }

  Future<bool> isBookmarked(String listingId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    
    try {
      final result = await _client
          .from('bookmarks')
          .select()
          .eq('user_id', userId)
          .eq('property_id', listingId)
          .maybeSingle();
      
      return result != null;
    } catch (e) {
      print('Error checking bookmark status: $e');
      return false;
    }
  }

  @override 
  void onClose() {
    super.onClose();
  }
}
