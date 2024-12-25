import 'package:get/get.dart';
import 'package:hoode/app/data/services/authservice.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/core/config/constants.dart';

class BookmarkService extends GetxService {
  final pb = PocketBase(POCKETBASE_URL);
  final bookmarks = <String>[].obs;
  final authService = Get.find<AuthService>();

  // TODO Fix User authentication
  Future<void> toggleBookmark(String propertyId) async {
    authService.requireAuth(() async {
      // Your existing bookmark logic here
      try {
      if (!pb.authStore.isValid) {
        Get.toNamed('/login');
      throw 'User must be logged in to bookmark properties';
    }
      final currentUser = pb.authStore.model.id;
      
      // Check if bookmark already exists for this user and property
      final existingBookmark = await pb.collection('bookmarks').getFirstListItem(
        'user = "$currentUser" && properties ~ "$propertyId"'
      ).catchError((_) => null);

      // Remove property from existing bookmark
      List properties = existingBookmark.data['properties'] ?? [];
      properties.remove(propertyId);
      
      if (properties.isEmpty) {
        // Delete bookmark record if no properties left
        await pb.collection('bookmarks').delete(existingBookmark.id);
      } else {
        // Update bookmark with remaining properties
        await pb.collection('bookmarks').update(existingBookmark.id, body: {
          'properties': properties,
        });
      }
      bookmarks.remove(propertyId);
        } catch (e) {
      rethrow;
    }
    });

    
  }

  Future<bool> isBookmarked(String propertyId) async {
    try {
      final currentUser = pb.authStore.model.id;
      final result = await pb.collection('bookmarks').getFirstListItem(
        'user = "$currentUser" && properties ~ "$propertyId"'
      ).catchError((_) => null);
      
      return result != null;
    } catch (e) {
      return false;
    }
  }

  Future<List<RecordModel>> getBookmarkedListings() async {
    try {
      final currentUser = pb.authStore.model.id;
      final bookmarkRecords = await pb.collection('bookmarks').getFirstListItem(
        'user = "$currentUser"'
      );
      
      List propertyIds = bookmarkRecords.data['properties'] ?? [];
      return await pb.collection('properties').getFullList(
        filter: 'id ~ "${propertyIds.join('" || id ~ "')}"',
      );
    } catch (e) {
      return [];
    }
  }
}
