import 'package:get/get.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:path_provider/path_provider.dart';

class ImageCropperController extends GetxController {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();
  Rect? cropRect = Rect.zero;
  EditActionDetails? action;


  Future<void> cropAndSaveImage() async {
    final state = editorKey.currentState;
    if (state != null) {
      cropRect = state.getCropRect();
      action = state.editAction!;

      final data = await cropImageDataWithNativeLibrary(
        state: state,
      );

      if (data != null) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File(
            '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png');
        await tempFile.writeAsBytes(data);
        Get.back(result: tempFile.path);
      }
    }
  }

  Future<Uint8List?> cropImageDataWithNativeLibrary({
    required ExtendedImageEditorState state,
  }) async {
    cropRect = state.getCropRect();
    action = state.editAction!;

    return state.rawImageData.sublist(0);
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
