import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatview/chatview.dart';
import 'package:hoode/app/data/services/authservice.dart';
// import 'package:hoode/app/core/config/constants.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/data/services/db_helper.dart';


class ChatViewController extends GetxController {
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  final messages = <Message>[].obs;
  final currentUser = Rxn<RecordModel>();
  final otherUser = Rxn<RecordModel>();
  late ChatController chatController;
  final authService = Get.find<AuthService>();
  final logger = Logger();

  @override
  void onInit() async {
    super.onInit();
    final conversationData = Get.arguments as Map<String, dynamic>;
    currentUser.value = await authService.getCurrentUser();
    otherUser.value = conversationData['agent'];
    setupChatController();
    subscribeToMessages();
  }

  void setupChatController() {
  final currentChatUser = ChatUser(
    id: currentUser.value?.id ?? '',
    name: currentUser.value?.data['name'] ?? '',
  );

  final otherChatUser = ChatUser(
    id: otherUser.value?.id ?? '',
    name: otherUser.value?.data['name'] ?? '',
  );

  chatController = ChatController(
    initialMessageList: messages,
    currentUser: currentChatUser,
    otherUsers: [otherChatUser],
    scrollController: ScrollController(),
  );
}




  void subscribeToMessages() {
    pb.collection('messages').subscribe('*', (e) {
      if (e.action == 'create' && e.record != null) {
        final newMessage = Message(
          id: e.record!.id,
          message: e.record!.data['content'] ?? '',
          createdAt: DateTime.parse(e.record!.get<String>('created')),
          sentBy: e.record!.data['sender_id'] ?? '',
        );
        messages.add(newMessage);
        chatController.addMessage(newMessage);
      }
    });
  }

  Future<void> sendMessage(String message, ReplyMessage? replyMessage,
      MessageType messageType) async {
    try {
      await pb.collection('messages').create(body: {
        'content': message,
        'sender_id': currentUser.value?.id,
        'receiver_id': otherUser.value?.id,
        'type': messageType.name,
        'reply_to': replyMessage?.messageId, // Using messageId instead of id
      });
    } catch (e) {
      logger.e('Error sending message: $e');
    }
  }

  @override
  void onClose() {
    pb.collection('messages').unsubscribe('*');
    super.onClose();
  }
}
