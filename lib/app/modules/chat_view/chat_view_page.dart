import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatview/chatview.dart';

import 'chat_view_controller.dart';

class ChatViewPage extends GetView<ChatViewController> {
  const ChatViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.otherUser.value?.data['name'] ?? 'Chat')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ChatView(
        chatController: controller.chatController,
        onSendTap: controller.sendMessage,
        chatViewState: ChatViewState.hasMessages,
        chatBackgroundConfig: ChatBackgroundConfiguration(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        sendMessageConfig: SendMessageConfiguration(
          replyMessageColor: Theme.of(context).primaryColor,
          defaultSendButtonColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
