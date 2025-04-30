import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/bookmarkservice.dart';
import 'package:share_plus/share_plus.dart';

class ListingDetailController extends GetxController {
  // Services
  final supabaseService = SupabaseService.to;
  final bookmarkService = Get.find<BookmarkService>();
  final log = Logger();
  
  // Get Supabase client
  SupabaseClient get _client => supabaseService.client;
  
  // Property data
  final property = Rxn<Map<String, dynamic>>();
  final isLoading = true.obs;
  final isBookmarked = false.obs;
  final isBooked = false.obs;
  final similarProperties = <Map<String, dynamic>>[].obs;
  final reviews = <Map<String, dynamic>>[].obs;
  final averageRating = 0.0.obs;
  
  // Agent data
  final agentName = "Unknown Agent".obs;
  final agentTitle = "Real Estate Agent".obs;
  final agentInitials = "UA".obs;
  final agentAvatar = "".obs;
  final agentId = "".obs;

  @override
  void onInit() async {
    super.onInit();
    
    final passedProperty = Get.arguments as Map<String, dynamic>?;
    final propertyId = Get.arguments is String ? Get.arguments as String : null;
    
    if (passedProperty != null) {
      property.value = passedProperty;
      await _loadAdditionalData();
      _incrementViewCount();
      isLoading(false);
    } else if (propertyId != null) {
      await loadPropertyDetails(propertyId);
    } else {
      log.e('No property data or ID provided');
      Get.snackbar('Error', 'Failed to load property details');
      isLoading(false);
    }
  }
  
  Future<void> loadPropertyDetails(String id) async {
    isLoading(true);
    try {
      // Get property details
      final result = await _client
          .from('properties')
          .select('*')
          .eq('id', id)
          .single();
      
      property.value = result;
      
      // Check if property is bookmarked
      isBookmarked.value = await bookmarkService.isBookmarked(id);
      
      // Load additional data
      await _loadAdditionalData();
      
      // Increment view count
      _incrementViewCount();
      
    } catch (e) {
      log.e('Error loading property: $e');
      Get.snackbar('Error', 'Failed to load property details');
    } finally {
      isLoading(false);
    }
  }
  
  Future<void> _loadAdditionalData() async {
    if (property.value == null) return;
    
    // Load agent data
    await _loadAgentData();
    
    // Load reviews
    await loadReviews();
    
    // Load similar properties
    await loadSimilarProperties();
    
    // Check if property is booked by current user
    await _checkBookingStatus();
  }
  
  Future<void> _loadAgentData() async {
    try {
      final agentId = property.value!['agent_id'];
      if (agentId == null) return;
      
      this.agentId.value = agentId;
      
      final agent = await _client
          .from('users')
          .select('*')
          .eq('id', agentId)
          .single();
      
      if (agent != null) {
        agentName.value = agent['full_name'] ?? "Unknown Agent";
        agentTitle.value = agent['title'] ?? "Real Estate Agent";
        agentAvatar.value = agent['avatar_url'] ?? "";
        
        // Generate initials from name
        if (agent['full_name'] != null) {
          final nameParts = agent['full_name'].split(' ');
          if (nameParts.length > 1) {
            agentInitials.value = "${nameParts[0][0]}${nameParts[1][0]}";
          } else if (nameParts.length == 1) {
            agentInitials.value = nameParts[0][0];
          }
        }
      }
    } catch (e) {
      log.e('Error loading agent data: $e');
    }
  }
  
  Future<void> loadReviews() async {
    try {
      final propertyId = property.value!['id'];
      
      final result = await _client
          .from('reviews')
          .select('''
            *,
            user:user_id (
              id, 
              full_name, 
              avatar_url
            )
          ''')
          .eq('property_id', propertyId)
          .order('created_at', ascending: false);
      
      // Process reviews to include user data
      final processedReviews = result.map((review) {
        return {
          ...review,
          'user_name': review['user']?['full_name'] ?? 'Unknown User',
          'user_avatar_url': review['user']?['avatar_url'],
        };
      }).toList();
      
      reviews.assignAll(processedReviews);
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
        totalRating += (review['rating'] as num).toDouble();
      }
      averageRating.value = totalRating / reviews.length;
    } else {
      averageRating.value = 0;
    }
  }
  
  Future<void> loadSimilarProperties() async {
    try {
      final propertyId = property.value!['id'];
      final category = property.value!['category'];
      
      if (category == null) return;
      
      final result = await _client
          .from('properties')
          .select('*')
          .eq('category', category)
          .neq('id', propertyId)
          .limit(5);
      
      similarProperties.assignAll(result);
    } catch (e) {
      log.e('Error loading similar properties: $e');
    }
  }
  
  Future<void> _checkBookingStatus() async {
    try {
      final propertyId = property.value!['id'];
      final currentUserId = _client.auth.currentUser?.id;
      
      if (currentUserId == null) return;
      
      final booking = await _client
          .from('bookings')
          .select()
          .eq('property_id', propertyId)
          .eq('user_id', currentUserId)
          .maybeSingle();
      
      isBooked.value = booking != null;
    } catch (e) {
      log.e('Error checking booking status: $e');
    }
  }
  
  Future<void> addReview(BuildContext context, double rating, String comment) async {
    try {
      final propertyId = property.value!['id'];
      final currentUserId = _client.auth.currentUser?.id;
      
      if (currentUserId == null) {
        Get.snackbar('Error', 'You must be logged in to add a review');
        return;
      }
      
      // Check if user has already reviewed this property
      final existingReview = await _client
          .from('reviews')
          .select()
          .eq('property_id', propertyId)
          .eq('user_id', currentUserId)
          .maybeSingle();
      
      if (existingReview != null) {
        // Update existing review
        await _client
            .from('reviews')
            .update({
              'rating': rating,
              'comment': comment,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existingReview['id']);
            
        Get.snackbar('Success', 'Your review has been updated');
      } else {
        // Create new review
        await _client
            .from('reviews')
            .insert({
              'property_id': propertyId,
              'user_id': currentUserId,
              'rating': rating,
              'comment': comment,
              'created_at': DateTime.now().toIso8601String(),
            });
            
        Get.snackbar('Success', 'Your review has been added');
      }
      
      // Reload reviews
      await loadReviews();
      
    } catch (e) {
      log.e('Error adding review: $e');
      Get.snackbar('Error', 'Failed to add review');
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
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your comment',
                border: OutlineInputBorder(),
              ),
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
              if (rating == 0) {
                Get.snackbar('Error', 'Please select a rating');
                return;
              }
              
              if (commentController.text.trim().isEmpty) {
                Get.snackbar('Error', 'Please enter a comment');
                return;
              }
              
              await addReview(context, rating, commentController.text);
              Get.back();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
  
  Future<void> toggleBookmark() async {
    if (property.value == null) return;
    
    final propertyId = property.value!['id'];
    await bookmarkService.toggleBookmark(propertyId);
    isBookmarked.toggle();
  }
  
  Future<void> bookProperty() async {
    try {
      final propertyId = property.value!['id'];
      final currentUserId = _client.auth.currentUser?.id;
      
      if (currentUserId == null) {
        Get.snackbar('Error', 'You must be logged in to book a property');
        return;
      }
      
      if (isBooked.value) {
        Get.snackbar('Already Booked', 'You have already booked this property');
        return;
      }
      
      // Create booking record
      await _client
          .from('bookings')
          .insert({
            'property_id': propertyId,
            'user_id': currentUserId,
            'booking_date': DateTime.now().toIso8601String(),
            'status': 'pending',
          });
      
      // Increment interaction count
      _incrementInteractionCount();
      
      // Create or get conversation with agent
      final conversation = await _createOrGetConversation();
      
      // Send booking message
      if (conversation != null) {
        await _client
            .from('messages')
            .insert({
              'conversation_id': conversation['id'],
              'sender_id': currentUserId,
              'content': 'I would like to book this property: ${property.value!['title']}',
              'type': 'booking',
              'created_at': DateTime.now().toIso8601String(),
              'read': false,
            });
      }
      
      isBooked(true);
      Get.snackbar('Success', 'Property booked successfully');
      
      // Navigate to chat
      if (conversation != null) {
        Get.toNamed('/chat-view', arguments: conversation);
      }
      
    } catch (e) {
      log.e('Error booking property: $e');
      Get.snackbar('Error', 'Failed to book property');
    }
  }
  
  Future<Map<String, dynamic>?> _createOrGetConversation() async {
    try {
      final propertyId = property.value!['id'];
      final currentUserId = _client.auth.currentUser?.id;
      
      if (currentUserId == null || agentId.value.isEmpty) return null;
      
      // Check if conversation already exists
      final existingConversation = await _client
          .from('conversations')
          .select()
          .contains('participants', [currentUserId, agentId.value])
          .eq('property_id', propertyId)
          .maybeSingle();
      
      if (existingConversation != null) {
        return existingConversation;
      }
      
      // Create new conversation
      final newConversation = await _client
          .from('conversations')
          .insert({
            'participants': [currentUserId, agentId.value],
            'property_id': propertyId,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      
      return newConversation;
      
    } catch (e) {
      log.e('Error creating conversation: $e');
      return null;
    }
  }
  
  void contactAgent() async {
    if (agentId.value.isEmpty) {
      Get.snackbar('Error', 'Agent information not available');
      return;
    }
    
    final conversation = await _createOrGetConversation();
    if (conversation != null) {
      Get.toNamed('/chat-view', arguments: conversation);
    } else {
      Get.snackbar('Error', 'Unable to start conversation with agent');
    }
  }
  
  void shareProperty(String title, String location, String price, String? imageUrl) {
    final shareText = '$title\n$location\nPrice: \$$price\n${imageUrl ?? ''}';
    Share.share(shareText);
  }
  
  Future<void> _incrementViewCount() async {
    try {
      final propertyId = property.value!['id'];
      final currentViewCount = property.value!['view_count'] as int? ?? 0;
      
            await _client
          .from('properties')
          .update({
            'view_count': currentViewCount + 1,
          })
          .eq('id', propertyId);
    } catch (e) {
      log.e('Error incrementing view count: $e');
    }
  }
  
  Future<void> _incrementInteractionCount() async {
    try {
      final propertyId = property.value!['id'];
      final currentInteractionCount = property.value!['interaction_count'] as int? ?? 0;
      
      await _client
          .from('properties')
          .update({
            'interaction_count': currentInteractionCount + 1,
          })
          .eq('id', propertyId);
    } catch (e) {
      log.e('Error incrementing interaction count: $e');
    }
  }
  
  void navigateToProperty(String propertyId) {
    // Save current scroll position or other state if needed
    Get.offAndToNamed('/listing-detail', arguments: propertyId);
  }
  
  @override
  void onClose() {
    super.onClose();
  }
}
