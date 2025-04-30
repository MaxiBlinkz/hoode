import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/modules/conversations/conversations_controller.dart';
//import 'conversations_controller.dart';

class ConversationsPage extends GetView<ConversationsController> {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : _buildConversationsList(context)),
            floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to contacts or user list to start a new chat
          Get.toNamed('/contacts');
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildConversationsList(BuildContext context) {
    return Obx(() {
      final conversations = controller.filteredConversations;
      
      if (conversations.isEmpty) {
        return _buildEmptyState(context);
      }
      
      return RefreshIndicator(
        onRefresh: controller.loadConversations,
        child: ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            return _buildConversationTile(context, conversation);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
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
            'No conversations yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start chatting with someone!',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Get.toNamed('/contacts');
            },
            icon: const Icon(Icons.add),
            label: const Text('New Chat'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, Map<String, dynamic> conversation) {
    final otherUser = conversation['other_user'];
    final unreadCount = conversation['unread_count'] ?? 0;
    final lastMessages = conversation['last_message'] as List?;
    final lastMessageTime = lastMessages != null && lastMessages.isNotEmpty
        ? controller.formatLastMessageTime(lastMessages.first['created_at'])
        : '';
    
    return ListTile(
      onTap: () => controller.openChat(conversation),
      leading: _buildAvatar(context, otherUser),
      title: Row(
        children: [
          Expanded(
            child: Text(
              otherUser?['full_name'] ?? 'Unknown User',
              style: TextStyle(
                fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            lastMessageTime,
            style: TextStyle(
              fontSize: 12,
              color: unreadCount > 0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              controller.getLastMessagePreview(conversation),
              style: TextStyle(
                color: unreadCount > 0
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildAvatar(BuildContext context, Map<String, dynamic>? user) {
    final avatarUrl = user?['avatar_url'];
    final name = user?['full_name'] ?? 'Unknown';
    
    return CircleAvatar(
      radius: 24,
      backgroundColor: Theme.of(context).colorScheme.primary,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
      child: avatarUrl == null
          ? Text(
              name[0],
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 18,
              ),
            )
          : null,
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Conversations'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search by name or message',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: controller.updateSearchQuery,
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.updateSearchQuery('');
              Navigator.pop(context);
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('SEARCH'),
          ),
        ],
      ),
    );
  }
}
