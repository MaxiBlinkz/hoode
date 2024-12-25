import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/data/services/bookmarkservice.dart';

class BookmarksController extends GetxController {
  final bookmarkService = Get.find<BookmarkService>();
  final bookmarkedListings = <RecordModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    isLoading(true);
    try {
      final listings = await bookmarkService.getBookmarkedListings();
      bookmarkedListings.assignAll(listings);
    } finally {
      isLoading(false);
    }
  }

  void removeBookmark(String listingId) async {
    await bookmarkService.toggleBookmark(listingId);
    loadBookmarks();
  }
}
