import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hoode/app/data/services/authservice.dart';
import 'db_helper.dart';
import 'package:pocketbase/pocketbase.dart';

class UserService extends GetxService {
  static UserService get to => Get.find();
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  final authService = Get.find<AuthService>();


  Future<void> upgradeUserToAgent(String userId, Map<String, dynamic> agentDetails) async {
    try {
      // First update the user record to mark them as an agent
      await pb.collection('users').update(userId, body: {
        'is_agent': true,
        'agent_status': 'active'
      });

      // Create corresponding agent record
      await pb.collection('agents').create(body: {
        'user': userId,  // Reference to user
        'name': agentDetails['name'],
        'title': agentDetails['title'],
        'bio': agentDetails['bio'],
        'specializations': agentDetails['specializations'],
        'license': agentDetails['license'],
        'contact': agentDetails['contact'],
        'avatar': agentDetails['avatar']
      });
    } catch (e) {
      throw 'Failed to upgrade user to agent: $e';
    }
  }

  Future<bool> isUserAgent(String userId) async {
    //final user = await pb.collection('users').getOne(userId);
    final user = await getCurrentUser();
    if (user?.id == null) return false;
    return user?.data['is_agent'] ?? false;
  }

  Future<RecordModel?> getAgentProfile(String userId) async {
    final records = await pb.collection('agents').getList(
      filter: 'user = "$userId"',
      expand: 'user'
    );
    return records.items.isNotEmpty ? records.items.first : null;
  }

  Future<RecordModel?> getCurrentUser() async {
    if (!pb.authStore.isValid || pb.authStore.record == null) {
      final token = GetStorage().read('authToken');
      final userData = GetStorage().read('userData');

      if (token != null && userData != null) {
        pb.authStore.save(token, RecordModel.fromJson(userData));
        await pb.collection('users').authRefresh();

        if (!pb.authStore.isValid) {
          Get.toNamed('/login');
          return null;
        }
      }
    }
    return pb.authStore.record;
  }
}
