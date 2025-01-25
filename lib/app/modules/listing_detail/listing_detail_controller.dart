import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../data/services/bookmarkservice.dart';
import '../../data/services/db_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class ListingDetailController extends GetxController {
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  final bookmarkService = Get.find<BookmarkService>();

  final property = Rxn<RecordModel>();
  final isLoading = true.obs;
  final isBookmarked = false.obs;
  final isBooked = false.obs;
  final similarProperties = <RecordModel>[].obs;
  final reviews = <RecordModel>[].obs;
  final averageRating = 0.0.obs;
  Logger log = Logger();

  @override
  void onInit() {
    super.onInit();
    final passedProperty = Get.arguments as RecordModel?;
    if (passedProperty != null) {
      property.value = passedProperty; // Use the passed property if available
      _incrementViewCount();
      loadSimilarProperties();
      loadReviews();
      isLoading(false);
    } else {
      // final propertyId = Get.arguments as String;
      // loadPropertyDetails(propertyId);
    }
  }

  Future<void> loadReviews() async {
    try {
      final response = await pb.collection('reviews').getList(
            filter: 'property="${property.value!.id}"',
            sort: '-created',
            expand: 'user',
          );
      reviews.value = response.items;
      _calculateAverageRating();
    } catch (e) {
      log.e('Error loading reviews: $e');
      reviews.value = [];
      averageRating.value = 0;
    }
  }

  void _calculateAverageRating() {
    if (reviews.isNotEmpty) {
      double totalRating = 0;
      for (var review in reviews) {
        totalRating += (review.data['rating'] as num).toDouble();
      }
      averageRating.value = totalRating / reviews.length;
    } else {
      averageRating.value = 0;
    }
  }

  Future<void> addReview(
      BuildContext context, double rating, String comment) async {
    try {
      final currentUser = await getCurrentUser();
      await pb.collection('reviews').create(body: {
        'property': property.value!.id,
        'user': currentUser?.id,
        'rating': rating,
        'comment': comment
      });
      Get.back(); //close the dialog
      loadReviews();
      Get.snackbar("Success", "Review Added");
    } catch (e) {
      log.e('Error adding review: $e');
      Get.snackbar("Error", 'Failed to add review');
    }
  }

  void showAddReviewDialog(BuildContext context) {
    final commentController = TextEditingController();
    double rating = 0;
    Get.dialog(
      AlertDialog(
        title: Text(
          'Add a Review',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Theme.of(context).primaryColor,
              ),
              onRatingUpdate: (newRating) {
                rating = newRating;
              },
            ),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Enter your comment'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await addReview(context, rating, commentController.text);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
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
        _incrementViewCount();
        loadSimilarProperties();
        loadReviews();
        return; // Exit the loop upon success
      } catch (e) {
        if (e is ClientException && e.statusCode == 429) {
          log.w('Rate limit hit. Retrying...');
          retryCount++;
          await Future.delayed(
              Duration(seconds: retryCount * 2)); // Exponential backoff
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
      final currentUser = await getCurrentUser();
      // Update property booking status
      await pb.collection('properties').update(property.value!.id, body: {
        'is_booked': true,
        'booked_by': currentUser?.id,
        'booking_date': DateTime.now().toIso8601String(),
      });
      _incrementInteractionCount();

      // Create a new conversation if it doesn't exist
      final conversation = await pb.collection('conversations').create(body: {
        'participants': [currentUser?.id, property.value!.data['agent']],
        'property_id': property.value!.id
      });

      // Send initial booking message
      await pb.collection('messages').create(body: {
        'content':
            'I would like to book this property: ${property.value!.data['title']}',
        'sender_id': currentUser?.id,
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

  Future<void> loadSimilarProperties() async {
    try {
      final response = await pb.collection('properties').getList(
            perPage: 5,
            filter:
                'category="${property.value!.data["category"]}" && id !="${property.value!.id}"',
          );
      similarProperties.value = response.items;
    } catch (e) {
      log.e('Error loading similar properties: $e');
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

  void toggleBookmark() {
    if (property.value != null) {
      bookmarkService.toggleBookmark(property.value!.id);
      isBookmarked.toggle();
    }
  }

  void contactAgent() async {
    final agent = property.value?.data['agent'];
    final currentUser = await getCurrentUser();
    final conversation = await pb.collection('conversations').create(body: {
      'participants': [currentUser?.id, property.value!.data['agent']],
      'property_id': property.value!.id
    });
    if (agent != null) {
      Get.toNamed('/chat-view', arguments: conversation);
    }
  }

  Future<void> shareProperty(
      String title, String location, String price, String? imageUrl) async {
    String shareText = '$title\n$location\nPrice: \$$price\n';
    if (imageUrl != null) {
      shareText += imageUrl;
    }
    Share.share(shareText);
  }

  Future<void> _incrementViewCount() async {
    try {
      final currentViewCount = property.value?.data['view_count'] as int? ?? 0;

      await pb.collection('properties').update(property.value!.id, body: {
        'view_count': currentViewCount + 1,
      });
    } catch (e) {
      log.e('Error incrementing view count: $e');
    }
  }

  Future<void> _incrementInteractionCount() async {
    try {
      final currentInteractionCount =
          property.value?.data['interaction_count'] as int? ?? 0;

      await pb.collection('properties').update(property.value!.id, body: {
        'interaction_count': currentInteractionCount + 1,
      });
    } catch (e) {
      log.e('Error incrementing interaction count: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
