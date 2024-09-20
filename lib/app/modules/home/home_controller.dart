import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:pocketbase/pocketbase.dart';

class HomeController extends GetxController {
  List<RecordModel> properties = [];
  var isLoading = true.obs;
  int currentPage = 1;
  int totalListing = 20;
  final pb = PocketBase(POCKETBASE_URL_ANDROID);

  Future<void> getProperties() async {
    isLoading(true);
    try {
      final response = await pb.collection('properties').getList(
            page: currentPage,
            perPage: totalListing,
            // filter: 'created >= "2022-01-01 00:00:00" && someField1 != someField2',
          );
      properties.assignAll(response.items);
      // properties.value =
      //     response.items.map((item) => Property.fromRecord(item)).toList();
      update();
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
