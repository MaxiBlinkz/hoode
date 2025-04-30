import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:lottie/lottie.dart';
import 'add_listing_controller.dart';

class AddListingPage extends GetView<AddListingController> {
  const AddListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Listing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrowLeft2),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: Obx(() => Column(
          children: [
            // Stepper indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildStepIndicator(context, 0, 'Basic Info'),
                  _buildStepConnector(context, 0),
                  _buildStepIndicator(context, 1, 'Details'),
                  _buildStepConnector(context, 1),
                  _buildStepIndicator(context, 2, 'Amenities'),
                  _buildStepConnector(context, 2),
                  _buildStepIndicator(context, 3, 'Images'),
                ],
              ),
            ),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildCurrentStepContent(context),
              ),
            ),
            
            // Bottom navigation
            _buildBottomNavigation(context),
          ],
        )),
      ),
    );
  }
  
  Widget _buildStepIndicator(BuildContext context, int step, String label) {
    final isActive = controller.currentStep.value >= step;
    final isCurrent = controller.currentStep.value == step;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey[300],
              shape: BoxShape.circle,
              border: isCurrent 
                  ? Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      width: 4,
                    )
                  : null,
            ),
            child: Center(
              child: isActive
                  ? const Icon(
                      IconlyBold.tickSquare,
                      color: Colors.white,
                      size: 16,
                    )
                  : Text(
                      '${step + 1}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isCurrent 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey[600],
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStepConnector(BuildContext context, int step) {
    final isActive = controller.currentStep.value > step;
    
    return Container(
      width: 20,
      height: 2,
      color: isActive 
          ? Theme.of(context).primaryColor 
          : Colors.grey[300],
    );
  }
  
  Widget _buildCurrentStepContent(BuildContext context) {
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
  }
  
  Widget _buildBasicInfoStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Basic Information'),
        const SizedBox(height: 16),
        
        // Title
        TextFormField(
          controller: controller.titleController,
          decoration: InputDecoration(
            labelText: 'Property Title',
            hintText: 'e.g. Modern Apartment in Downtown',
            prefixIcon: const Icon(IconlyLight.document),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Description
        TextFormField(
          controller: controller.descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            hintText: 'Describe your property...',
            prefixIcon: const Icon(IconlyLight.paper),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Category
        Text(
          'Property Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.categories.map((category) {
            return Obx(() => ChoiceChip(
              label: Text(category),
              selected: controller.category.value == category,
              onSelected: (selected) {
                if (selected) {
                  controller.category.value = category;
                }
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              labelStyle: TextStyle(
                color: controller.category.value == category
                    ? Theme.of(context).primaryColor
                    : Colors.black,
                fontWeight: controller.category.value == category
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ));
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildDetailsStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Property Details'),
        const SizedBox(height: 16),
        
        // Price
        TextFormField(
          controller: controller.priceController,
          decoration: InputDecoration(
            labelText: 'Price',
            hintText: 'e.g. 250000',
            prefixIcon: const Icon(IconlyLight.wallet),
            prefixText: '\$ ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixText: 'USD',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a price';
            }
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Please enter a valid price';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Bedrooms and Bathrooms
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.bedroomsController,
                decoration: InputDecoration(
                  labelText: 'Bedrooms',
                  hintText: 'e.g. 3',
                  prefixIcon: const Icon(IconlyLight.home),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controller.bathroomsController,
                decoration: InputDecoration(
                  labelText: 'Bathrooms',
                  hintText: 'e.g. 2',
                  prefixIcon: const Icon(Icons.bathtub_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Area
        TextFormField(
          controller: controller.areaController,
          decoration: InputDecoration(
            labelText: 'Area',
            hintText: 'e.g. 1500',
            prefixIcon: const Icon(Icons.square_foot),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixText: 'sq ft',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the area';
            }
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Please enter a valid area';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Address
        TextFormField(
          controller: controller.addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            hintText: 'Enter property address',
            prefixIcon: const Icon(IconlyLight.location),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              icon: const Icon(IconlyLight.discovery),
              onPressed: controller.getCurrentLocation,
              tooltip: 'Use current location',
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an address';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        
        // Location coordinates display
        Obx(() {
          if (controller.latitude.value != 0.0 && controller.longitude.value != 0.0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    IconlyBold.location,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Location set: ${controller.latitude.value.toStringAsFixed(4)}, ${controller.longitude.value.toStringAsFixed(4)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
  
  Widget _buildAmenitiesStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Amenities & Features'),
        const SizedBox(height: 8),
        Text(
          'Select all amenities that apply to your property',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.availableAmenities.map((amenity) {
            return Obx(() => FilterChip(
              label: Text(amenity),
              selected: controller.amenities.contains(amenity),
              onSelected: (selected) {
                controller.toggleAmenity(amenity);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: controller.amenities.contains(amenity)
                    ? Theme.of(context).primaryColor
                    : Colors.black,
                fontWeight: controller.amenities.contains(amenity)
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ));
          }).toList(),
        ),
        
        const SizedBox(height: 24),
        
        // Selected amenities count
        Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(
                controller.amenities.isEmpty
                    ? IconlyLight.infoSquare
                    : IconlyBold.tickSquare,
                color: controller.amenities.isEmpty
                    ? Colors.orange
                    : Colors.green,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.amenities.isEmpty
                      ? 'Please select at least one amenity'
                      : '${controller.amenities.length} amenities selected',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: controller.amenities.isEmpty
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
  
  Widget _buildImagesStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Property Images'),
        const SizedBox(height: 8),
        Text(
          'Add high-quality images of your property (min. 1, max. 10)',
                    style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        
        // Add images button
        Obx(() => controller.images.length < 10 ? Center(
          child: InkWell(
            onTap: controller.addImage,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    IconlyLight.image,
                    size: 48,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap to add images',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select up to 10 images',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) : const SizedBox.shrink()),
        
        const SizedBox(height: 16),
        
        // Image preview grid
        Obx(() {
          if (controller.images.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/animations/empty_images.json',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No images added yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add at least one image to continue',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: controller.images.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(controller.images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: InkWell(
                      onTap: () => controller.removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        index == 0 ? 'Main' : '#${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }),
        
        const SizedBox(height: 16),
        
        // Image count indicator
        Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(
                controller.images.isEmpty
                    ? IconlyLight.infoSquare
                    : IconlyBold.image,
                color: controller.images.isEmpty
                    ? Colors.orange
                    : Colors.green,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.images.isEmpty
                      ? 'Please add at least one image'
                      : '${controller.images.length} ${controller.images.length == 1 ? 'image' : 'images'} added',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: controller.images.isEmpty
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
              ),
              if (controller.images.length < 10)
                TextButton(
                  onPressed: controller.addImage,
                  child: const Text('Add More'),
                ),
            ],
          ),
        )),
        
        // Submit section
        if (controller.currentStep.value == 3)
          _buildSubmitSection(context),
      ],
    );
  }
  
  Widget _buildSubmitSection(BuildContext context) {
    return Obx(() {
      if (controller.status.value == Status.loading) {
        return Column(
          children: [
            const SizedBox(height: 32),
            Lottie.asset(
              'assets/animations/uploading.json',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            Text(
              'Uploading your listing...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: controller.uploadProgress.value,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      }
      
      if (controller.status.value == Status.error) {
        return Column(
          children: [
            const SizedBox(height: 32),
            Lottie.asset(
              'assets/animations/error.json',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Creating Listing',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.submitListing,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      }
      
      return Column(
        children: [
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(
                  IconlyBold.tickSquare,
                  color: Colors.green,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  'Ready to Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your listing is ready to be published. Click the button below to submit.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
  
  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          if (controller.currentStep.value > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.previousStep,
                icon: const Icon(IconlyLight.arrowRight),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          if (controller.currentStep.value > 0)
            const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Obx(() {
              if (controller.currentStep.value == 3) {
                return ElevatedButton.icon(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.submitListing,
                  icon: const Icon(IconlyBold.upload),
                  label: const Text('Submit Listing'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
              
              return ElevatedButton.icon(
                onPressed: controller.nextStep,
                icon: const Icon(IconlyLight.arrowRight),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
