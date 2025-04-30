import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient client;
  
  static SupabaseService get to => Get.find<SupabaseService>();
  
  @override
  void onInit() {
    super.onInit();
    client = Supabase.instance.client;
  }
}
