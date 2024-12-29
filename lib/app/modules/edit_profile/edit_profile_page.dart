import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import '../../core/theme/colors.dart';
import 'package:latlong2/latlong.dart';
import 'edit_profile_controller.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(IconlyLight.arrowLeft2),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(() => CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.selectedImage.value != null
                        ? FileImage(controller.selectedImage.value!)
                        : null,
                    child: controller.selectedImage.value == null
                        ? IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: controller.getImage,
                          )
                        : null,
                  )),
              const SizedBox(height: 24),
              _buildTextField(
                controller: controller.firstnameController,
                label: 'First Name',
                icon: IconlyLight.profile,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.lastnameController,
                label: 'Last Name',
                icon: IconlyLight.profile,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.contactInfoController,
                label: 'Contact Info',
                icon: IconlyLight.call,
              ),
              const SizedBox(height: 16),
              CountryStateCityPicker(
                country: controller.countryController,
                state: controller.stateController,
                city: controller.cityController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.locationController,
                      label: 'Location',
                      icon: IconlyLight.location,
                      readOnly: true,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(IconlyLight.location),
                    onPressed: controller.getCurrentLocation,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.updateProfile,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
