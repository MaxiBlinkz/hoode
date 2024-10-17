import 'package:get/get.dart';

class NavBarController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index){
    tabIndex(index);
  }

  @override
  void onInit() {
    super.onInit();
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
