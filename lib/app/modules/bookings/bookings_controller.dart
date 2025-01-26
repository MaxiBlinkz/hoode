import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../data/services/db_helper.dart';
import 'package:logger/logger.dart';

class BookingsController extends GetxController {
  late final PocketBase pb;
  final bookings = <RecordModel>[].obs;
  final isLoading = true.obs;
  final logger = Logger();

  @override
  void onInit() async{
    super.onInit();
    String url = await DbHelper.getPocketbaseUrl();
    pb = PocketBase(url);
    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      if (!pb.authStore.isValid || pb.authStore.record == null) {
        return;
      }
      final records = await pb.collection('bookings').getFullList(
          filter: 'agent = "${pb.authStore.record?.id}" || user = "${pb.authStore.model.id}"',
      );
      bookings.value = records;
    } catch (e) {
      logger.e('Error loading bookings: $e');
    } finally {
      isLoading.value = false;
    }
  }
}