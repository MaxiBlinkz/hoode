import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class ListingDetailController extends GetxController {
  //int _id = 2;
  //set id(int _id) => id = _id;
  //final int id = 0;
  // final RxInt id = 0.obs;
  // var property = {}.obs;
  // var isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    // id.value = Get.arguments ?? 0;
    // fetchProperty();
  }

  // void fetchProperty() async {
  //   try {
  //     final response = await Supabase.instance.client
  //         .from('properties')
  //         .select()
  //         .eq('id', '${id.value}')
  //         .single();

  //     if (response.isNotEmpty) {
  //       property.value = response;
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', '$e');
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
