import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_view_controller.dart';
import 'package:intl/intl.dart';
class ChatViewPage extends GetView<ChatViewController> {
  const ChatViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            children: [
              CircleAvatar(
                child: Text(controller.otherUser.value?.data['name']?[0] ?? '?'),
              ),
              const SizedBox(width: 10,),
               Text(controller.otherUser.value?.data['name'] ?? 'Chat'),
            ],
          ),
          actions: [
            IconButton(icon: const Icon(Icons.video_call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
          ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              reverse: true,
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                  final message = controller.messages[controller.messages.length - 1 - index];
                  final isMe = message.sentBy == controller.currentUser.value?.id;
                   return _buildChatMessage(context, message, isMe);
                },
              ),
            ),
          ),
           _buildChatInput(context),
        ],
      ),
    );
  }

 Widget _buildChatMessage(BuildContext context, message, bool isMe) {
    final time = DateFormat('hh:mm a').format(message.createdAt);
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surface,
          borderRadius:  isMe ? const BorderRadius.only(
             topLeft: Radius.circular(12),
             topRight: Radius.circular(12),
             bottomLeft: Radius.circular(12),
            ) :  const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child:  Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
                message.message,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: isMe ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface),
              ),
               Align(
                alignment: Alignment.bottomRight,
                 child: Text(
                time,
               style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
               ),
               ),
          ],
        ),
      ),
    );
  }
   Widget _buildChatInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
           color: Theme.of(context).shadowColor.withValues(
                  red: 0,
                  green: 0,
                  blue: 0,
                  alpha: 0.2,
                ),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
           IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {
                // Handle mic button press
              },
            ),
          Expanded(
            child: TextField(
               controller: controller.messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                 filled: true,
                  fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              ),
                onChanged: (text) {
                    controller.updateText(text);
                },
               onSubmitted: (text) async {
                   if(text.trim().isNotEmpty){
                    await controller.sendMessage(text, null, MessageType.text);
                      controller.messageController.clear();
                   }
                }
            ),
          ),
         IconButton(
            icon: const Icon(Icons.send),
             onPressed: () async {
                if(controller.messageController.text.trim().isNotEmpty){
                    await controller.sendMessage(controller.messageController.text, null, MessageType.text);
                      controller.messageController.clear();
                   }
            },
          ),
        ],
      ),
    );
  }
}