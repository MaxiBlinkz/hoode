import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'add_listing_controller.dart';

class AddListingPage extends GetView<AddListingController> {
  const AddListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create New Listing'),
          leading: IconButton(
            icon: const Icon(IconlyLight.arrowLeft2),
            onPressed: () => Get.back(),
          ),
        ),
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Obx(() => EasyStepper(
                    activeStep: controller.currentStep.value,
                    onStepReached: (index) =>
                        controller.currentStep.value = index,
                    steps: [
                      EasyStep(
                        icon: const Icon(IconlyLight.paper),
                        title: 'Basic Info',
                      ),
                      EasyStep(
                        icon: const Icon(IconlyLight.wallet),
                        title: 'Details',
                      ),
                      EasyStep(
                        icon: const Icon(IconlyLight.star),
                        title: 'Amenities',
                      ),
                      EasyStep(
                        icon: const Icon(IconlyLight.image),
                        title: 'Images',
                      ),
                    ],
                    borderThickness: 2,
                    padding: const EdgeInsets.all(16),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() {
                    switch (controller.currentStep.value) {
                      case 0:
                        return _buildBasicInfoStep();
                      case 1:
                        return _buildDetailsStep();
                      case 2:
                        return _buildAmenitiesStep();
                      case 3:
                        return _buildImagesStep();
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => controller.currentStep.value > 0
                  ? Expanded(
                      child: OutlinedButton(
                        onPressed: controller.previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text(
                          'Previous',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.currentStep.value == 3
                              ? controller.submitListing
                              : controller.nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.white,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              controller.currentStep.value == 3
                                  ? 'Create Listing'
                                  : 'Next',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    )),
              ),
            ],
          ),
        ));
  }

  Widget _buildBasicInfoStep() {
  return Column(
    children: [
      Obx(() => TextFormField(
        decoration: const InputDecoration(labelText: 'Title'),
        // key is crucial for reactive form
        key: const ValueKey('title'),
        initialValue: controller.title.value,
        onChanged: (value) => controller.title.value = value,
        validator: (value) => value?.isEmpty ?? true ? 'Title required' : null,
      )),
      const SizedBox(height: 16),
      Obx(() => DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Category'),
            key: const ValueKey('category'),
            value: controller.category.value.isNotEmpty ? controller.category.value : null, // Key change here
            items: controller.categories.map((category) => DropdownMenuItem(
                  value: category, // Ensure unique values here
                  child: Text(category),
                )).toList(),
            onChanged: (value) {
              controller.category.value = value ?? ''; //Maintain this for convenience
            },
            validator: (value) => value == null ? 'Category required' : null,
          )),
    ],
  );
}


  Widget _buildDetailsStep() {
    return Column(
      children: [
        Obx(() {
          return TextFormField(
            decoration: const InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(),
              prefixIcon: Icon(IconlyLight.wallet),
              prefixText: '\$',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                controller.price.value = double.tryParse(value) ?? 0,
          );
        }),
        const SizedBox(height: 16),
        Row(
          children: [
            Obx(() {
              return Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Bedrooms',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(IconlyLight.home),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      controller.bedrooms.value = int.tryParse(value) ?? 0,
                ),
              );
            }),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() {
                return TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Bathrooms',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.bathtub),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      controller.bathrooms.value = int.tryParse(value) ?? 0,
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenitiesStep() {
    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.availableAmenities.map((amenity) {
          return FilterChip(
            label: Text(amenity),
            selected: controller.amenities.contains(amenity),
            onSelected: (_) => controller.toggleAmenity(amenity),
            selectedColor: Theme.of(Get.context!).colorScheme.primaryContainer,
          );
        }).toList(),
      );
    });
  }

  Widget _buildImagesStep() {
    return Column(
      children: [
        Obx(() {
          return ElevatedButton.icon(
            onPressed: controller.addImage,
            icon: const Icon(IconlyBold.image),
            label: const Text('Add Photos'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Obx(() => Obx(() {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: controller.images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          controller.images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: const Icon(Icons.remove_circle),
                          color: Colors.red,
                          onPressed: () => controller.removeImage(index),
                        ),
                      ),
                    ],
                  );
                },
              );
            })),
      ],
    );
  }
}
