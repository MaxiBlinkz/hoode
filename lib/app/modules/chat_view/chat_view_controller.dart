import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/authservice.dart';
import 'package:logger/logger.dart';

class ChatViewController extends GetxController {
  // Services
  final supabaseService = SupabaseService.to;
  final authService = Get.find<AuthService>();
  final logger = Logger();
  
  // Get Supabase client
  SupabaseClient get _client => supabaseService.client;

  // Chat data
  final messages = <types.Message>[].obs;
  final conversation = Rxn<Map<String, dynamic>>();
  final otherUser = Rxn<Map<String, dynamic>>();
  final currentUser = Rxn<types.User>();
  final isLoading = true.obs;

  // Realtime channel for messages
  RealtimeChannel? _messagesChannel;
  
  @override
  void onInit() async {
    super.onInit();
    
    // Get conversation data from arguments
    final conversationData = Get.arguments as Map<String, dynamic>;
    conversation.value = conversationData;

    // Load current user data
    await _loadCurrentUser();

    // Load other user data
    await _loadOtherUser();

    // Load messages
    await _loadMessages();

    // Subscribe to new messages
    _subscribeToMessages();

    // Mark conversation as read
    _markConversationAsRead();

    isLoading(false);
  }
  
  Future<void> _loadCurrentUser() async {
  try {
    // Get Supabase client
    final supabase = SupabaseService.to.client;
    
    // Get current user from Supabase
    final currentUserId = supabase.auth.currentUser?.id;
    
    if (currentUserId != null) {
      // Fetch user profile data from the database
      final userData = await supabase
          .from('users')
          .select()
          .eq('id', currentUserId)
          .single();
      
      if (userData != null) {
        // Create a flutter_chat_types User
        currentUser.value = types.User(
          id: userData['id'] ?? '',
          firstName: _extractFirstName(userData['full_name']),
          lastName: _extractLastName(userData['full_name']),
          imageUrl: userData['avatar_url'],
        );
      } else {
        Get.snackbar('Error', 'Unable to load user data');
        Get.back();
      }
    } else {
      Get.snackbar('Error', 'You must be logged in');
      Get.toNamed('/login');
    }
  } catch (e) {
    logger.e('Error loading current user: $e');
    Get.snackbar('Error', 'Unable to load user data');
    Get.back();
  }
}
  
  String _extractFirstName(String? fullName) {
    if (fullName == null || fullName.isEmpty) return '';
    final parts = fullName.split(' ');
    return parts.first;
  }
  
  String _extractLastName(String? fullName) {
    if (fullName == null || fullName.isEmpty) return '';
    final parts = fullName.split(' ');
    if (parts.length > 1) {
      return parts.sublist(1).join(' ');
    }
    return '';
  }

  Future<void> _loadOtherUser() async {
    try {
      // Get the other participant's ID from the conversation
      final participants =
          List<String>.from(conversation.value!['participants']);
      final currentUserId = _client.auth.currentUser?.id;

      if (currentUserId == null) {
        Get.snackbar('Error', 'User not authenticated');
        Get.back();
        return;
      }

      // Find the ID that's not the current user's
      final otherUserId = participants.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '',
      );
      
      if (otherUserId.isEmpty) {
        Get.snackbar('Error', 'Could not find other participant');
        Get.back();
        return;
      }

      // Get the other user's data
      final userData = await _client
          .from('users')
          .select('*')
          .eq('id', otherUserId)
          .single();

      otherUser.value = userData;
    } catch (e) {
      logger.e('Error loading other user: $e');
      Get.snackbar('Error', 'Unable to load other user data');
    }
  }

  Future<void> _loadMessages() async {
    try {
      final conversationId = conversation.value!['id'];

      // Get messages for this conversation
      final result = await _client
          .from('messages')
          .select('*, sender:sender_id(*)')
          .eq('conversation_id', conversationId)
          .order('created_at');

      // Convert to flutter_chat_types Message objects
      final chatMessages = result.map<types.Message>((msg) {
        final senderId = msg['sender_id'];
        final senderName = msg['sender']?['full_name'] ?? 'Unknown';
        final senderAvatar = msg['sender']?['avatar_url'];

        final author = types.User(
          id: senderId,
          firstName: _extractFirstName(senderName),
          lastName: _extractLastName(senderName),
          imageUrl: senderAvatar,
        );
        
        // Determine message type
        final messageType = msg['type'] ?? 'text';

        if (messageType == 'image') {
          return types.ImageMessage(
            author: author,
            id: msg['id'],
            name: 'image.jpg', // Add the required 'name' parameter
            uri: msg['content'],
            size: 200 * 200, // Use a numeric value for size (width * height)
            createdAt: DateTime.parse(msg['created_at']).millisecondsSinceEpoch,
            status: msg['read'] == true
                ? types.Status.seen
                : types.Status.delivered,
          );
        } else if (messageType == 'file') {
          return types.FileMessage(
            author: author,
            id: msg['id'],
            name: msg['file_name'] ?? 'File',
            size: msg['file_size'] ?? 0,
            uri: msg['content'],
            createdAt: DateTime.parse(msg['created_at']).millisecondsSinceEpoch,
            status: msg['read'] == true
                ? types.Status.seen
                : types.Status.delivered,
          );
        } else {
          return types.TextMessage(
            author: author,
            id: msg['id'],
            text: msg['content'],
            createdAt: DateTime.parse(msg['created_at']).millisecondsSinceEpoch,
            status: msg['read'] == true
                ? types.Status.seen
                : types.Status.delivered,
          );
        }
      }).toList();

      messages.assignAll(chatMessages);
    } catch (e) {
      logger.e('Error loading messages: $e');
      Get.snackbar('Error', 'Unable to load messages');
    }
  }

  void _subscribeToMessages() {
    final conversationId = conversation.value!['id'];

    // Create a channel for this conversation
    _messagesChannel = _client.channel('conversation:$conversationId');

    // Listen for new messages
    _messagesChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) async {
            // Get the complete message with sender info
            final messageId = payload.newRecord!['id'];
            final newMessageData = await _client
                .from('messages')
                .select('*, sender:sender_id(*)')
                .eq('id', messageId)
                .single();

            final senderId = newMessageData['sender_id'];
            final senderName =
                newMessageData['sender']?['full_name'] ?? 'Unknown';
            final senderAvatar = newMessageData['sender']?['avatar_url'];

            final author = types.User(
              id: senderId,
              firstName: _extractFirstName(senderName),
              lastName: _extractLastName(senderName),
              imageUrl: senderAvatar,
            );

            // Determine message type
            final messageType = newMessageData['type'] ?? 'text';

            types.Message newMessage;
            
            if (messageType == 'image') {
              newMessage = types.ImageMessage(
                author: author,
                id: newMessageData['id'],
                name: 'image.jpg',
                uri: newMessageData['content'],
                size: 200 * 200,
                createdAt: DateTime.parse(newMessageData['created_at'])
                    .millisecondsSinceEpoch,
                status: newMessageData['read'] == true
                    ? types.Status.seen
                    : types.Status.delivered,
              );
            } else if (messageType == 'file') {
              newMessage = types.FileMessage(
                author: author,
                id: newMessageData['id'],
                name: newMessageData['file_name'] ?? 'File',
                size: newMessageData['file_size'] ?? 0,
                uri: newMessageData['content'],
                createdAt: DateTime.parse(newMessageData['created_at'])
                    .millisecondsSinceEpoch,
                status: newMessageData['read'] == true
                    ? types.Status.seen
                    : types.Status.delivered,
              );
            } else {
              newMessage = types.TextMessage(
                author: author,
                id: newMessageData['id'],
                text: newMessageData['content'],
                createdAt: DateTime.parse(newMessageData['created_at'])
                    .millisecondsSinceEpoch,
                status: newMessageData['read'] == true
                    ? types.Status.seen
                    : types.Status.delivered,
              );
            }

            // Add to messages list
            messages.add(newMessage);
            
            // Mark message as read if it's not from the current user
            if (newMessageData['sender_id'] != _client.auth.currentUser?.id) {
              _markMessageAsRead(messageId);
            }
          },
        )
        .subscribe();
  }

  Future<void> _markConversationAsRead() async {
    try {
      final conversationId = conversation.value!['id'];
      final currentUserId = _client.auth.currentUser?.id;

      if (currentUserId == null) return;

      // Mark all messages in this conversation as read
      await _client
          .from('messages')
          .update({'read': true})
          .eq('conversation_id', conversationId)
          .neq('sender_id', currentUserId);
    } catch (e) {
      logger.e('Error marking conversation as read: $e');
    }
  }
  
  Future<void> _markMessageAsRead(String messageId) async {
    try {
      await _client.from('messages').update({'read': true}).eq('id', messageId);
    } catch (e) {
      logger.e('Error marking message as read: $e');
    }
  }
  
  void handleSendPressed(types.PartialText message) async {
    try {
      final currentUserId = _client.auth.currentUser?.id;
      final conversationId = conversation.value!['id'];

      if (currentUserId == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      // Generate a temporary ID for optimistic UI update
      final tempId = const Uuid().v4();

      // Create a temporary message for immediate display
      final textMessage = types.TextMessage(
        author: currentUser.value!,
        id: tempId,
        text: message.text,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        status: types.Status.sending,
      );

      // Add to messages list for immediate UI update
      messages.add(textMessage);

      // Send the message to the server
      await _client.from('messages').insert({
        'content': message.text,
        'sender_id': currentUserId,
        'conversation_id': conversationId,
        'type': 'text',
        'read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // The new message will be added via the realtime subscription
      // and the temporary message will be replaced
      
    } catch (e) {
      logger.e('Error sending message: $e');
      Get.snackbar('Error', 'Failed to send message');
    }
  }
  
  @override
  void onClose() {
    // Unsubscribe from the channel
    _messagesChannel?.unsubscribe();
    
    super.onClose();
  }
}
