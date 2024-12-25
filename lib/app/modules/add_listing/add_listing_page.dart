import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/colors.dart';
import 'add_listing_controller.dart';

class AddListingPage extends GetView<AddListingController> {
  const AddListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Listing'),
        leading: IconButton(
          icon: const Icon(IconlyLight.arrowLeft2),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.title.value = value,
              validator: (value) => 
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => controller.description.value = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => 
                  controller.price.value = double.tryParse(value) ?? 0,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.addImage,
              icon: const Icon(IconlyBold.image),
              label: const Text('Add Images'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value 
                  ? null 
                  : controller.submitListing,
              child: controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('Submit Listing'),
            )),
      ),
    );
  }
}
