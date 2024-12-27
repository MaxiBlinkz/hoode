import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/services/bookmarkservice.dart';

class ListingDetailController extends GetxController {
  final pb = PocketBase(POCKETBASE_URL);
  final bookmarkService = Get.find<BookmarkService>();

  final property = Rxn<RecordModel>();
  final isLoading = true.obs;
  final isBookmarked = false.obs;
  Logger log = Logger();

  // ListingDetailController.dart
@override
void onInit() {
  super.onInit();
  final passedProperty = Get.arguments as RecordModel?;
  if (passedProperty != null) {
    property.value = passedProperty; // Use the passed property if available
    isLoading(false);
  } else {
    final propertyId = Get.arguments as String;
    loadPropertyDetails(propertyId);
  }
}


  Future<void> loadPropertyDetails(String id) async {
  isLoading(true);
  const maxRetries = 3;
  int retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      property.value = await pb.collection('properties').getOne(id);
      log.i('Property loaded: ${property.value?.data}');
      isBookmarked.value = await bookmarkService.isBookmarked(id);
      return; // Exit the loop upon success
    } catch (e) {
      if (e is ClientException && e.statusCode == 429) {
        log.w('Rate limit hit. Retrying...');
        retryCount++;
        await Future.delayed(Duration(seconds: retryCount * 2)); // Exponential backoff
      } else {
        log.e('Error loading property: $e');
        Get.snackbar('Error', 'Failed to load property details');
        break;
      }
    }
  }
  isLoading(false); // Ensure the loading state is updated
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
