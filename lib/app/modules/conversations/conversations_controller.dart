import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/authservice.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class ConversationsController extends GetxController {
  // Services
  final supabaseService = SupabaseService.to;
  final authService = Get.find<AuthService>();
  final logger = Logger();
  
  // Get Supabase client
  SupabaseClient get _client => supabaseService.client;

  // Conversations data
  final conversations = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final filteredConversations = <Map<String, dynamic>>[].obs;

  // Realtime channel for conversations
  RealtimeChannel? _conversationsChannel;
  
  @override
  void onInit() async {
    super.onInit();
    
    // Load conversations
    await loadConversations();

    // Subscribe to conversation updates
    _subscribeToConversations();

    isLoading(false);
  }
  
  Future<void> loadConversations() async {
    try {
      final currentUserId = _client.auth.currentUser?.id;
      if (currentUserId == null) return;
      
      // Get all conversations where the current user is a participant
      final result = await _client.from('conversations').select('''
            *,
            participants,
            last_message:messages(
              id,
              content, 
              created_at, 
              sender_id, 
              read,
              type
            )
          ''').contains('participants', [
        currentUserId
      ]).order('updated_at', ascending: false);

      // Process the conversations to include other user info
      final processedConversations = await Future.wait(
        result.map((conv) async {
          // Extract the other user ID from participants
          final participants = List<String>.from(conv['participants']);
          final otherUserId = participants.firstWhere(
            (id) => id != currentUserId,
            orElse: () => '',
          );
          
          if (otherUserId.isEmpty) return conv;

          // Get the other user's data
          try {
            final userData = await _client
                .from('users')
                .select('*')
                .eq('id', otherUserId)
                .single();

            // Add other user data to conversation
            conv['other_user'] = userData;

            // Calculate unread count
            final unreadCountResponse = await _client
                .from('messages')
                .select('id')
                .eq('conversation_id', conv['id'])
                .eq('read', false)
                .neq('sender_id', currentUserId)
                .count(CountOption.exact);

            conv['unread_count'] = unreadCountResponse;

            return conv;
          } catch (e) {
            logger.e('Error loading user data for conversation: $e');
            return conv;
          }
        }),
      );

      conversations.assignAll(processedConversations);
      _filterConversations();
    } catch (e) {
      logger.e('Error loading conversations: $e');
      Get.snackbar('Error', 'Unable to load conversations');
    }
  }
  
  void _filterConversations() {
    if (searchQuery.value.isEmpty) {
      filteredConversations.assignAll(conversations);
      return;
    }
    
    final query = searchQuery.value.toLowerCase();
    final filtered = conversations.where((conv) {
      final otherUser = conv['other_user'];
      if (otherUser == null) return false;

      final name = otherUser['full_name']?.toString().toLowerCase() ?? '';
      final lastMessage =
          conv['last_message']?[0]?['content']?.toString().toLowerCase() ?? '';

      return name.contains(query) || lastMessage.contains(query);
    }).toList();

    filteredConversations.assignAll(filtered);
  }
  
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _filterConversations();
  }
  
  void _subscribeToConversations() {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) return;

    // Create a channel for conversations
    _conversationsChannel = _client.channel('user_conversations');

    // Listen for new messages that affect conversations
    _conversationsChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            // Reload conversations to update last message and unread count
            loadConversations();
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            // Reload conversations to update read status
            loadConversations();
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'conversations',
          callback: (payload) {
            // Reload conversations to include new ones
            loadConversations();
          },
        )
        .subscribe();
  }
  
  void openChat(Map<String, dynamic> conversation) {
    Get.toNamed('/chat-view', arguments: conversation);
  }
  
  String formatLastMessageTime(String? timestamp) {
    if (timestamp == null) return '';

    final messageTime = DateTime.parse(timestamp);
    final now = DateTime.now();

    // If message is from today, show time
    if (messageTime.year == now.year &&
        messageTime.month == now.month &&
        messageTime.day == now.day) {
      return DateFormat('h:mm a').format(messageTime);
    }

    // If message is from this week, show day name
    if (now.difference(messageTime).inDays < 7) {
      return DateFormat('E').format(messageTime);
    }

    // Otherwise show date
    return DateFormat('MMM d').format(messageTime);
  }

  String getLastMessagePreview(Map<String, dynamic> conversation) {
    final lastMessages = conversation['last_message'] as List?;
    if (lastMessages == null || lastMessages.isEmpty) {
      return 'No messages yet';
    }

    final lastMessage = lastMessages.first;
    final messageType = lastMessage['type'] ?? 'text';

    if (messageType == 'image') {
      return '📷 Photo';
    } else if (messageType == 'file') {
      return '📎 File';
    } else {
      return lastMessage['content'] ?? '';
    }
  }

  Future<void> createNewChat(String userId) async {
    try {
      final currentUserId = _client.auth.currentUser?.id;
      if (currentUserId == null) return;

      // Check if conversation already exists
      final existingConversation = await _client
          .from('conversations')
          .select()
          .contains('participants', [currentUserId, userId]).maybeSingle();

      if (existingConversation != null) {
        // Open existing conversation
        openChat(existingConversation);
      } else {
        // Create new conversation
        final newConversation = await _client
            .from('conversations')
            .insert({
              'participants': [currentUserId, userId],
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            })
            .select()
            .single();

        openChat(newConversation);
      }
    } catch (e) {
      logger.e('Error creating new chat: $e');
      Get.snackbar('Error', 'Unable to create new chat');
    }
  }
  
  @override
  void onClose() {
    // Unsubscribe from the channel
    _conversationsChannel?.unsubscribe();
    
    super.onClose();
  }
}
