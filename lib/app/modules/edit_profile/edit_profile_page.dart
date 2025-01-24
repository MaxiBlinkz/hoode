import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'edit_profile_controller.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Obx(() => CircleAvatar(
                              radius: 50,
                              backgroundImage: controller.selectedImage.value != null
                                  ? FileImage(controller.selectedImage.value!)
                                  : null,
                              child: controller.selectedImage.value == null
                                  ? const Icon(IconlyLight.profile, size: 50)
                                  : null,
                            )),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: IconButton(
                                  icon: Icon(IconlyLight.camera, color: Colors.white),
                                  onPressed: () => controller.getImage(context)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                      controller: controller.bioController,
                      label: 'Bio',
                      icon: IconlyLight.document,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Contact Information',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: controller.contactInfoController,
                      label: 'Phone Number',
                      icon: IconlyLight.call,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Location',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CSCPickerPlus(
                      onCountryChanged: (value) => controller.countryController.text = value ?? '',
                      onStateChanged: (value) => controller.stateController.text = value ?? '',
                      onCityChanged: (value) => controller.cityController.text = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(IconlyLight.location),
                      title: const Text('Set Precise Location'),
                      trailing: IconButton(
                        icon: const Icon(IconlyLight.location),
                        onPressed: controller.getCurrentLocation,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value 
                            ? null 
                            : controller.updateProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : const Text('Save Changes'),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
