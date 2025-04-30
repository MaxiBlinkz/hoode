import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import '../../data/services/supabase_service.dart';
import '../../data/enums/enums.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddListingController extends GetxController {
  // Form key and step control
  final formKey = GlobalKey<FormState>();
  final currentStep = 0.obs;
  
  // Basic info
  final title = ''.obs;
  final description = ''.obs;
  final category = ''.obs;
  
  // Details
  final price = 0.0.obs;
  final bedrooms = 0.obs;
  final bathrooms = 0.obs;
  final area = 0.0.obs;
  final address = ''.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  
  // Amenities
  final amenities = <String>[].obs;
  
  // Images
  final images = <File>[].obs;
  final uploadProgress = 0.0.obs;
  
  // State management
  final isLoading = false.obs;
  final status = Status.initial.obs;
  final errorMessage = ''.obs;
  
  // Services
  final Logger logger = Logger(printer: PrettyPrinter());
  final _picker = ImagePicker();
  
  // Supabase client
  SupabaseClient get _client => SupabaseService.to.client;
  
  // Available options
  final availableAmenities = [
    'Parking',
    'Pool',
    'Garden',
    'Security',
    'Gym',
    'Air Conditioning',
    'Furnished',
    'Pet Friendly',
    'Storage',
    'Elevator',
    'Balcony',
    'Terrace',
    'Fireplace',
    'Wheelchair Access',
    'EV Charging',
  ];

  final categories = [
    'House',
    'Apartment',
    'Villa',
    'Condo',
    'Townhouse',
    'Studio',
    'Penthouse',
    'Loft',
    'Cottage',
    'Farmhouse',
    'Bungalow',
    'Duplex',
    'Mobile Home',
  ];
  
  // Form controllers for validation
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final bedroomsController = TextEditingController();
  final bathroomsController = TextEditingController();
  final areaController = TextEditingController();
  final addressController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    initControllers();
  }
  
  void initControllers() {
    titleController.addListener(() => title.value = titleController.text);
    descriptionController.addListener(() => description.value = descriptionController.text);
    priceController.addListener(() {
      final value = double.tryParse(priceController.text) ?? 0.0;
      price.value = value;
    });
    bedroomsController.addListener(() {
      final value = int.tryParse(bedroomsController.text) ?? 0;
      bedrooms.value = value;
    });
    bathroomsController.addListener(() {
      final value = int.tryParse(bathroomsController.text) ?? 0;
      bathrooms.value = value;
    });
    areaController.addListener(() {
      final value = double.tryParse(areaController.text) ?? 0.0;
      area.value = value;
    });
    addressController.addListener(() => address.value = addressController.text);
  }

  void toggleAmenity(String amenity) {
    if (amenities.contains(amenity)) {
      amenities.remove(amenity);
    } else {
      amenities.add(amenity);
    }
  }

  void nextStep() {
    if (validateStep(currentStep.value)) {
      if (currentStep.value < 3) {
        currentStep.value++;
      }
    } else {
      Get.snackbar(
        'Required Fields',
        'Please fill in all required fields before proceeding',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> addImage() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (var xFile in pickedFiles) {
          // Crop image before adding
          final croppedFile = await cropImage(xFile.path);
          if (croppedFile != null) {
            images.add(File(croppedFile.path));
          }
        }
        
        if (images.isNotEmpty) {
          Get.snackbar(
            "Images Selected", 
            "${pickedFiles.length} images added successfully",
            snackPosition: SnackPosition.BOTTOM, 
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            duration: const Duration(seconds: 2),
          );
        }
      }
    } catch (e) {
      logger.e('Error picking images: $e');
      Get.snackbar(
        'Error',
        'Failed to select images: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  Future<CroppedFile?> cropImage(String imagePath) async {
    try {
      return await ImageCropper().cropImage(
        sourcePath: imagePath,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.ratio3x2,
        //   CropAspectRatioPreset.ratio4x3,
        //   CropAspectRatioPreset.ratio16x9,
        // ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Get.theme.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: false,
          ),
        ],
      );
    } catch (e) {
      logger.e('Error cropping image: $e');
      return null;
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
    }
  }
  
  Future<void> getLocationFromAddress() async {
    if (address.value.isEmpty) return;
    
    try {
      List<Location> locations = await locationFromAddress(address.value);
      if (locations.isNotEmpty) {
        latitude.value = locations.first.latitude;
        longitude.value = locations.first.longitude;
        logger.i('Location found: ${latitude.value}, ${longitude.value}');
      }
    } catch (e) {
      logger.e('Error getting location from address: $e');
    }
  }
  
  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Location Required',
          'Please enable location services in your device settings',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition();
        latitude.value = position.latitude;
        longitude.value = position.longitude;
        
        // Get address from coordinates
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, 
            position.longitude
          );
          
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            final formattedAddress = [
              place.street,
              place.locality,
              place.administrativeArea,
              place.postalCode,
              place.country,
            ].where((element) => element != null && element.isNotEmpty)
              .join(', ');
            
            address.value = formattedAddress;
            addressController.text = formattedAddress;
          }
        } catch (e) {
          logger.e('Error getting address from coordinates: $e');
        }
      }
    } catch (e) {
      logger.e('Error getting current location: $e');
      Get.snackbar(
        'Error',
        'Failed to get current location: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> submitListing() async {
    if (!formKey.currentState!.validate()) return;
    
    if (images.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    status(Status.loading);
    isLoading(true);
    uploadProgress.value = 0.0;

    try {
      // Get current user
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      
      // Get location from address if not already set
      if (latitude.value == 0.0 || longitude.value == 0.0) {
        await getLocationFromAddress();
      }
      
      // Create a unique folder name for this listing's images
      final listingId = const Uuid().v4();
      final imageUrls = <String>[];
      
      // Upload images
      for (var i = 0; i < images.length; i++) {
        final file = images[i];
        final fileExt = path.extension(file.path);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i$fileExt';
        final filePath = 'properties/$listingId/$fileName';
        
        // Upload file to Supabase Storage
        await _client.storage.from('listings').upload(
          filePath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
        
        // Get public URL
        final imageUrl = _client.storage.from('listings').getPublicUrl(filePath);
        imageUrls.add(imageUrl);
        
        // Update progress
        uploadProgress.value = (i + 1) / images.length;
      }
      
      // Create listing in database
      await _client.from('properties').insert({
        'title': title.value,
        'description': description.value,
        'price': price.value,
        'category': category.value.toLowerCase(),
        'bedrooms': bedrooms.value,
        'bathrooms': bathrooms.value,
        'area': area.value,
        'address': address.value,
        'latitude': latitude.value,
        'longitude': longitude.value,
        'amenities': amenities,
        'images': imageUrls,
        'user_id': user.id,
        'status': 'active',
        'created_at': DateTime.now().toIso8601String(),
        'view_count': 0,
        'interaction_count': 0,
      });

      logger.i('Listing created successfully');
      status(Status.success);
      
      Get.back();
      Get.snackbar(
        'Success',
        'Listing created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      status(Status.error);
      errorMessage.value = e.toString();
      logger.e('Error creating listing: $e');
      
      Get.snackbar(
        'Error',
        'Failed to create listing: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading(false);
    }
  }

  bool validateStep(int step) {
    switch (step) {
      case 0: // Basic Info
        return title.value.isNotEmpty && 
               description.value.isNotEmpty && 
               category.value.isNotEmpty;
      case 1: // Details
        return price.value > 0 && 
               bedrooms.value > 0 && 
               bathrooms.value > 0 && 
               area.value > 0 && 
               address.value.isNotEmpty;
      case 2: // Amenities
        return amenities.isNotEmpty;
      case 3: // Images
        return images.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    bedroomsController.dispose();
    bathroomsController.dispose();
    areaController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
