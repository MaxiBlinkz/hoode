import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';

class MessagesController extends GetxController {
  final pb = PocketBase(POCKETBASE_URL);
  final conversations = <RecordModel>[].obs;
  final logger = Logger();

  @override
  void onInit() {
    super.onInit();
    loadConversations();
    subscribeToConversations();
  }

  Future<void> loadConversations() async {
    try {
      final records = await pb.collection('conversations').getFullList(
            filter: 'participants ~ "${pb.authStore.model.id}"',
            expand: 'participants,last_message',
          );
      conversations.value = records;
    } catch (e) {
      logger.e('Error loading conversations: $e');
    }
  }

  void subscribeToConversations() {
  pb.collection('conversations').subscribe('*', (e) {
    if (e.action == 'create' && e.record != null) {
      conversations.add(e.record!);
    } else if (e.action == 'update' && e.record != null) {
      final index = conversations.indexWhere((c) => c.id == e.record!.id);
      if (index != -1) {
        conversations[index] = e.record!;
      }
    }
  });
}


  void openChat(RecordModel conversation) {
    Get.toNamed('/chat-view', arguments: conversation);
  }

  @override
  void onClose() {
    pb.collection('conversations').unsubscribe('*');
    super.onClose();
  }
}
