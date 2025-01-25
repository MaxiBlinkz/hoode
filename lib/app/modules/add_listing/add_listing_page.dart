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
                        return _buildBasicInfoStep(context);
                      case 1:
                        return _buildDetailsStep(context);
                      case 2:
                        return _buildAmenitiesStep(context);
                      case 3:
                        return _buildImagesStep(context);
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

Widget _buildBasicInfoStep(BuildContext context) {
    return Column(
      children: [
        Obx(() => TextFormField(
              decoration: InputDecoration(
                  labelText: 'Property Title',
                  hintText: "Enter property title",
                  prefixIcon:  Icon(IconlyLight.home, color: Theme.of(context).colorScheme.onSurface),
                 ),
              key: const ValueKey('title'),
              initialValue: controller.title.value,
              onChanged: (value) => controller.title.value = value,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Title required' : null,
            )),
        const SizedBox(height: 16),
        Obx(() => DropdownButtonFormField<String>(
              decoration:  InputDecoration(
                labelText: 'Property Type',
                hintText: "Select property type",
                  prefixIcon:  Icon(IconlyLight.category, color: Theme.of(context).colorScheme.onSurface),
              ),
              key: const ValueKey('category'),
              value: controller.category.value.isNotEmpty ? controller.category.value : null,
              items: controller.categories.map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  )).toList(),
              onChanged: (value) {
                controller.category.value = value ?? '';
              },
              validator: (value) => value == null ? 'Category required' : null,
            )),
      ],
    );
  }

  Widget _buildDetailsStep(BuildContext context) {
  return Column(
    children: [
      Obx(() {
        return TextFormField(
          decoration:  InputDecoration(
              labelText: 'Price',
             hintText: "Enter price",
              prefixIcon: Icon(IconlyLight.wallet, color: Theme.of(context).colorScheme.onSurface),
              prefixText: '\$',
            ),
          keyboardType: TextInputType.number,
          onChanged: (value) =>
              controller.price.value = double.tryParse(value) ?? 0,
        );
      }),
      const SizedBox(height: 16),
         Obx(() =>  TextFormField(
            decoration: InputDecoration(
                labelText: 'Property Size',
                 hintText: "Enter property size",
                prefixIcon:  Icon(Icons.crop_square_outlined, color: Theme.of(context).colorScheme.onSurface),
                suffixText: "sq ft"
              ),
            keyboardType: TextInputType.number,
            onChanged: (value) =>
            controller.area.value = double.tryParse(value) ?? 0,
          )),
        const SizedBox(height: 16),
      Row(
        children: [
          Obx(() {
            return Expanded(
              child: TextFormField(
                  decoration:  InputDecoration(
                   labelText: 'Bedrooms',
                   hintText: "Enter number of bedrooms",
                     prefixIcon: Icon(IconlyLight.home, color: Theme.of(context).colorScheme.onSurface),
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
                  decoration: InputDecoration(
                      labelText: 'Bathrooms',
                      hintText: "Enter number of bathrooms",
                       prefixIcon: Icon(Icons.bathtub, color: Theme.of(context).colorScheme.onSurface),
                    ),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    controller.bathrooms.value = int.tryParse(value) ?? 0,
              );
            }),
          ),
        ],
      ),

         const SizedBox(height: 16),
         Obx(() =>  TextFormField(
            decoration: InputDecoration(
                labelText: 'Address',
                 hintText: "Enter property address",
                  prefixIcon: Icon(IconlyLight.location, color: Theme.of(context).colorScheme.onSurface),
              ),
            onChanged: (value) =>
            controller.address.value = value,
          )),
    ],
  );
}


  Widget _buildAmenitiesStep(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.availableAmenities.map((amenity) {
          return FilterChip(
            label: Text(amenity),
            selected: controller.amenities.contains(amenity),
            onSelected: (_) => controller.toggleAmenity(amenity),
              backgroundColor: Theme.of(context).colorScheme.surface,
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            labelStyle: TextStyle(
              color: controller.amenities.contains(amenity)
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
               shadowColor: Theme.of(context).shadowColor.withValues(
                  red: 0,
                  green: 0,
                  blue: 0,
                  alpha: 10,
                ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildImagesStep(BuildContext context) {
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