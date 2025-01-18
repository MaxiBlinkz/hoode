import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../core/config/constants.dart';
import '../../data/services/bookmarkservice.dart';
import '../../data/services/db_helper.dart';


class ListingDetailController extends GetxController {
  // final pb = PocketBase(POCKETBASE_URL);
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  final bookmarkService = Get.find<BookmarkService>();

  final property = Rxn<RecordModel>();
  final isLoading = true.obs;
  final isBookmarked = false.obs;
  final isBooked = false.obs;
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

Future<void> bookProperty() async {
    try {
      // Update property booking status
      await pb.collection('properties').update(property.value!.id, body: {
        'is_booked': true,
        'booked_by': pb.authStore.model.id,
        'booking_date': DateTime.now().toIso8601String(),
      });

      // Create a new conversation if it doesn't exist
      final conversation = await pb.collection('conversations').create(body: {
        'participants': [pb.authStore.model.id, property.value!.data['agent']],
        'property_id': property.value!.id
      });

      // Send initial booking message
      await pb.collection('messages').create(body: {
        'content':
            'I would like to book this property: ${property.value!.data['title']}',
        'sender_id': pb.authStore.model.id,
        'conversation_id': conversation.id,
        'type': 'booking'
      });

      isBooked(true);
      Get.toNamed('/chat-view', arguments: conversation);
    } catch (e) {
      log.e('Error booking property: $e');
      Get.snackbar('Error', 'Failed to book property');
    }
  }

  void toggleBookmark() {
    if (property.value != null) {
      bookmarkService.toggleBookmark(property.value!.id);
      isBookmarked.toggle();
    }
  }

  void contactAgent() async {
    final agent = property.value?.data['agent'];
    if (agent != null) {
      Get.toNamed('/chat-view', arguments: {
        'agent': agent,
        'property': property.value,
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
