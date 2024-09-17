import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  var properties = [].obs;
  var isLoading = true.obs;

  Future<void> getProperties() async {
    isLoading(true);
    try {
      properties.value =
          await Supabase.instance.client.from('properties')
          .select()
          .limit(1);
    } catch (e) {
      print('Error fetching properties: $e');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    getProperties();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
