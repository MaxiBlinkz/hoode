import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart';
import 'chat_view_controller.dart';

class ChatViewPage extends GetView<ChatViewController> {
  const ChatViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => controller.otherUser.value != null
            ? Row(
                children: [
                  _buildAvatar(context),
                  const SizedBox(width: 10),
                  Text(
                    controller.otherUser.value!['full_name'] ?? 'Chat',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            : const Text('Chat')),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              // Implement video call functionality
              Get.snackbar('Coming Soon', 'Video call feature coming soon!');
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show more options
              _showMoreOptions(context);
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.currentUser.value == null) {
          return const Center(child: Text('Unable to load user data'));
        }
        
        return Chat(
          messages: controller.messages,
          user: controller.currentUser.value!,
          onSendPressed: controller.handleSendPressed,
                    theme: DefaultChatTheme(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            primaryColor: Theme.of(context).colorScheme.primary,
            secondaryColor: Theme.of(context).colorScheme.surface,
            inputBackgroundColor: Theme.of(context).colorScheme.surface,
            sentMessageBodyTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 16,
            ),
            receivedMessageBodyTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
            userAvatarNameColors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
          showUserNames: true,
          showUserAvatars: true,
          dateLocale: 'en_US',
          timeFormat: DateFormat.Hm(),
          dateFormat: DateFormat('MMMM d, y'),
          emptyState: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start the conversation!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          customBottomWidget: _buildCustomInputField(context),
        );
      }),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final avatarUrl = controller.otherUser.value?['avatar_url'];
    
    return CircleAvatar(
      radius: 18,
      backgroundColor: Theme.of(context).colorScheme.primary,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
      child: avatarUrl == null
          ? Text(
              controller.otherUser.value?['full_name']?[0] ?? '?',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            )
          : null,
    );
  }

  Widget? _buildCustomInputField(BuildContext context) {
    // Return null to use the default input field
    return null;
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                Navigator.pop(context);
                // Implement search functionality
                Get.snackbar('Coming Soon', 'Search functionality coming soon!');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Mute notifications'),
              onTap: () {
                Navigator.pop(context);
                // Implement mute functionality
                Get.snackbar('Coming Soon', 'Mute functionality coming soon!');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Clear chat'),
              onTap: () {
                Navigator.pop(context);
                // Implement clear chat functionality
                _showClearChatConfirmation(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block user', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // Implement block user functionality
                _showBlockUserConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearChatConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear chat'),
        content: const Text('Are you sure you want to clear all messages? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Implement clear chat functionality
              Get.snackbar('Coming Soon', 'Clear chat functionality coming soon!');
            },
            child: const Text('CLEAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showBlockUserConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Block user'),
        content: const Text('Are you sure you want to block this user? You will no longer receive messages from them.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Implement block user functionality
              Get.snackbar('Coming Soon', 'Block user functionality coming soon!');
            },
            child: const Text('BLOCK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
