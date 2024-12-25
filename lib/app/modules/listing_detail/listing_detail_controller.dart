import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/services/bookmarkservice.dart';

class ListingDetailController extends GetxController {
  final pb = PocketBase(POCKETBASE_URL);
  final bookmarkService = Get.find<BookmarkService>();
  
  final property = Rxn<RecordModel>();
  final isLoading = true.obs;
  final isBookmarked = false.obs;

  @override
  void onInit() {
    super.onInit();
    final propertyId = Get.arguments as String;
    loadPropertyDetails(propertyId);
  }

  Future<void> loadPropertyDetails(String id) async {
    isLoading(true);
    try {
      property.value = await pb.collection('properties').getOne(id);
      isBookmarked.value = await bookmarkService.isBookmarked(id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load property details');
    } finally {
      isLoading(false);
    }
  }

  void toggleBookmark() {
    if (property.value != null) {
      bookmarkService.toggleBookmark(property.value!.id);
      isBookmarked.toggle();
    }
  }

  void contactAgent() {
    // Implement agent contact logic
  }
}
