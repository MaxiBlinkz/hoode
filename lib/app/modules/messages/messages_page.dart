import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'messages_controller.dart';

class MessagesPage extends GetView<MessagesController> {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.conversations.length,
            itemBuilder: (context, index) {
              final conversation = controller.conversations[index];
              final participants =
                  conversation.expand?['participants'] as List<dynamic>?;
              final otherParticipant = participants?.firstWhere(
                (p) => p.id != controller.pb.authStore.model.id,
                orElse: () => null,
              );
              final lastMessage = conversation.expand?['last_message'];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(otherParticipant?.data['name']?[0] ?? '?'),
                ),
                title: Text(otherParticipant?.data['name'] ?? 'Unknown',  style: Theme.of(context).textTheme.bodyMedium,),
                subtitle: Text(
                  lastMessage?.toString() ?? 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatDate(conversation.data['created']),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Icon(IconlyLight.arrowRight2, color: Colors.grey[400]),
                  ],
                ),
                onTap: () => controller.openChat(conversation),
              );
            },
          )),
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      return _getDayOfWeek(date.weekday);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _getDayOfWeek(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }
}