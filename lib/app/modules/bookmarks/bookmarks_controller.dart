import 'package:get/get.dart';
import 'package:hoode/app/modules/home/home_controller.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../data/services/bookmarkservice.dart';

class BookmarksController extends GetxController {
  static BookmarksController get to => Get.find();
  
  final bookmarkService = Get.find<BookmarkService>();
  final bookmarkedListings = <RecordModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
    // Add listener for bookmark changes
    ever(bookmarkService.bookmarks, (_) => loadBookmarks());
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
    // loadBookmarks();
    bookmarkedListings.removeWhere((listing) => listing.id == listingId);
    Get.find<HomeController>().refreshAfterBookmarkChange();
}

  @override 
  void onClose() {
    super.onClose();
  }
}

