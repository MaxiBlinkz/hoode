import 'dart:io';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:hoode/app/modules/image_cropper/image_cropper_controller.dart';

class ImageCropperPage extends GetView<ImageCropperController> {
  final String imagePath;
  final double aspectRatio;

  const ImageCropperPage({
    Key? key,
    required this.imagePath,
    required this.aspectRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Image'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => controller.cropAndSaveImage(),
          ),
        ],
      ),
      body: ExtendedImage.file(
        File(imagePath),
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        extendedImageEditorKey: controller.editorKey,
        initEditorConfigHandler: (state) {
          return EditorConfig(
            maxScale: 8.0,
            cropRectPadding: const EdgeInsets.all(20.0),
            hitTestSize: 20.0,
            cropAspectRatio: aspectRatio,
          );
        },
      ),
    );
  }
}


