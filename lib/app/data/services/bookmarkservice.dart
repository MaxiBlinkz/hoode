import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'authservice.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'db_helper.dart';

class BookmarkService extends GetxService {
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  final bookmarks = <String>[].obs;
  final authService = Get.find<AuthService>();
  Logger logger = Logger();

  Future<void> toggleBookmark(String propertyId) async {
    authService.requireAuth(() async {
      try {
        if (!pb.authStore.isValid || pb.authStore.record == null) {
        // Get stored auth data
        final token = GetStorage().read('authToken');
        final userData = GetStorage().read('userData');
        
        if (token != null && userData != null) {
          // Restore auth state
          pb.authStore.save(token, RecordModel.fromJson(userData));
          await pb.collection('users').authRefresh();
          
          if (!pb.authStore.isValid) {
            Get.toNamed('/login');
            return;
          }
        }
      }

        final currentUser = pb.authStore.record!.id;
        final existingBookmark = await pb
            .collection('bookmarks')
            .getFirstListItem(
                'user = "$currentUser" && properties ~ "$propertyId"')
            .catchError((error) => RecordModel.fromJson({
                  'collectionId': 'bookmarks',
                  'collectionName': 'bookmarks',
                  'created': DateTime.now().toIso8601String(),
                  'updated': DateTime.now().toIso8601String(),
                  'id': '',
                  'properties': []
                }));


        List properties = existingBookmark.data['properties'] ?? [];
        properties.remove(propertyId);

        if (properties.isEmpty) {
          await pb.collection('bookmarks').delete(existingBookmark.id);
        } else {
          await pb.collection('bookmarks').update(existingBookmark.id, body: {
            'properties': properties,
          });
        }
        bookmarks.remove(propertyId);
      } catch (e) {
        logger.e('Bookmark operation failed: $e');
      }
    });
  }

  Future<bool> isBookmarked(String propertyId) async {
    try {
      if (!pb.authStore.isValid || pb.authStore.record == null) {
        return false;
      }
      final currentUser = pb.authStore.record?.id;
      final result = await pb
          .collection('bookmarks')
          .getFirstListItem(
              'user = "$currentUser" && properties ~ "$propertyId"')
          .catchError((error) => RecordModel.fromJson({
                'collectionId': 'bookmarks',
                'collectionName': 'bookmarks',
                'created': DateTime.now().toIso8601String(),
                'updated': DateTime.now().toIso8601String(),
                'id': '',
                'properties': []
              }));

      return result.id.isNotEmpty;
    } catch (e) {
      return false;
    }
}

  Future<List<RecordModel>> getBookmarkedListings() async {
    try {
      if (!pb.authStore.isValid || pb.authStore.record == null) {
        return [];
      }
      final currentUser = pb.authStore.record?.id;
      final bookmarkRecords = await pb
          .collection('bookmarks')
          .getFirstListItem('user = "$currentUser"');

      List propertyIds = bookmarkRecords.data['properties'] ?? [];
      return await pb.collection('properties').getFullList(
            filter: 'id ~ "${propertyIds.join('" || id ~ "')}"',
          );
    } catch (e) {
      return [];
    }
  }
}
