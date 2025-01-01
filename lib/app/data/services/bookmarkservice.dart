import 'package:flutter/material.dart';
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
      final currentUser = await getCurrentUser();
      if (currentUser == null) return;

      RecordModel bookmarkRecord;
      
      try {
        bookmarkRecord = await pb
            .collection('bookmarks')
            .getFirstListItem("user = '${currentUser.id}'");
        // Update existing bookmark
        List properties = bookmarkRecord.data['properties'] ?? [];
        if (properties.contains(propertyId)) {
          properties.remove(propertyId);
        } else {
          properties.add(propertyId);
        }

        await pb.collection('bookmarks').update(bookmarkRecord.id, body: {
          'user': currentUser.id,
          'properties': properties,
        });

        if (properties.contains(propertyId)) {
          bookmarks.add(propertyId);
        } else {
          bookmarks.remove(propertyId);
        }
        
      } catch (_) {
        // Create new bookmark record
        await pb.collection('bookmarks').create(body: {
          'user': currentUser.id,
          'properties': [propertyId]
        });
        bookmarks.add(propertyId);
      }
    } catch (e) {
      logger.e('Bookmark operation failed: $e');
    }
  });
}




  Future<bool> isBookmarked(String propertyId) async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser?.id == null) return false;

      final result = await pb
          .collection('bookmarks')
          .getFirstListItem(
              'user = "${currentUser?.id}" && properties ~ "$propertyId"')
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
      final currentUser = await getCurrentUser();
      if (currentUser?.id == null) return [];
      final bookmarkRecords = await pb
          .collection('bookmarks')
          .getFirstListItem('user = "${currentUser?.id}"');

      List propertyIds = bookmarkRecords.data['properties'] ?? [];
      return await pb.collection('properties').getFullList(
            filter: 'id ~ "${propertyIds.join('" || id ~ "')}"',
          );
    } catch (e) {
      return [];
    }
  }

  Future<List> loadBookmarks() async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null) return [];

      final bookmarkRecord = await pb
          .collection('bookmarks')
          .getFirstListItem('user = "${currentUser.id}"');

      List properties = bookmarkRecord.data['properties'] ?? [];
      bookmarks.value = properties.cast<String>();
      return bookmarks;
    } catch (e) {
      bookmarks.clear();
      return [];
    }
  }

  Future<RecordModel?> getCurrentUser() async {
  try {
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
  } catch (e) {
    Get.snackbar(
      'Connection Error',
      'Unable to connect to server. Please check your internet connection.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return null;
  }
}

}
