import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hoode/app/data/services/db_helper.dart';

class MessagesController extends GetxController {
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  final conversations = <RecordModel>[].obs;
  final logger = Logger();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (pb.authStore.isValid) {
      loadConversations();
      subscribeToConversations();
    }
  }

  Future<void> loadConversations() async {
    try {
      if (!pb.authStore.isValid || pb.authStore.model == null) {
        return;
      }
      
      final records = await pb.collection('conversations').getFullList(
            filter: 'participants ~ "${pb.authStore.model.id}"',
            expand: 'participants,last_message',
          );
      conversations.value = records;
    } catch (e) {
      logger.e('Error loading conversations: $e');
    } finally {
      isLoading(false);
    }
  }

  void subscribeToConversations() {
    if (!pb.authStore.isValid) return;
    
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