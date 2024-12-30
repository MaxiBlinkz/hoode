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
        final currentUser = await authService.getCurrentUser();
        if (currentUser == null) return;

        // Try to get existing bookmark or create new one
        RecordModel bookmarkRecord;
        try {
          bookmarkRecord = await pb
              .collection('bookmarks')
              .getFirstListItem('user = "$currentUser"');
        } catch (e) {
          // Create new bookmark record if none exists
          bookmarkRecord = await pb.collection('bookmarks').create(body: {
            'user': currentUser,
            'properties': [propertyId]
          });
          bookmarks.add(propertyId);
          return;
        }

        // Update existing bookmark
        List properties = bookmarkRecord.data['properties'] ?? [];
        if (properties.contains(propertyId)) {
          properties.remove(propertyId);
        } else {
          properties.add(propertyId);
        }

        await pb.collection('bookmarks').update(bookmarkRecord.id, body: {
          'properties': properties,
        });

        if (properties.contains(propertyId)) {
          bookmarks.add(propertyId);
        } else {
          bookmarks.remove(propertyId);
        }
      } catch (e) {
        logger.e('Bookmark operation failed: $e');
      }
    });
  }

  Future<bool> isBookmarked(String propertyId) async {
    try {
      final currentUser = await authService.getCurrentUser();
      if (currentUser == null) return false;

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
      final currentUser = await authService.getCurrentUser();
      if (currentUser == null) return [];
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

  // Future<List> loadBookmarks() async {
  //   try {
  //     final currentUser = await authService.getCurrentUser();
  //     if (currentUser == null) return [];

  //     final bookmarkRecord = await pb
  //         .collection('bookmarks')
  //         .getFirstListItem('user = "$currentUser"');

  //     List properties = bookmarkRecord.data['properties'] ?? [];
  //     bookmarks.value = properties.cast<String>();
  //     return bookmarks;
  //   } catch (e) {
  //     bookmarks.clear();
  //     return [];
  //   }
  // }
}
