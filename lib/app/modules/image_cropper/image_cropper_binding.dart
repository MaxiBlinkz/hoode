import 'package:get/get.dart';

import 'image_cropper_controller.dart';

class ImageCropperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageCropperController>(
      ImageCropperController.new,
    );
  }
}
