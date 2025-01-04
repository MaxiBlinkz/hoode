import 'package:country_state_city_pro/country_state_city_pro.dart';
// import 'package:csc_picker/csc_picker.dart';
import 'package:country_state_city_picker_2/country_state_city_picker.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../core/theme/colors.dart';
import 'profile_setup_controller.dart';

import 'package:easy_stepper/easy_stepper.dart';

class ProfileSetupPage extends GetView<ProfileSetupController> {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() => EasyStepper(
                      activeStep: controller.currentStep.value,
                      steps: [
                        EasyStep(
                          customStep: Icon(
                            Icons.person_outline,
                            color: controller.currentStep.value >= 0
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                          title: 'Personal',
                        ),
                        EasyStep(
                          customStep: Icon(
                            Icons.location_on_outlined,
                            color: controller.currentStep.value >= 1
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                          title: 'Location',
                        ),
                        EasyStep(
                          customStep: Icon(
                            Icons.photo_camera_outlined,
                            color: controller.currentStep.value >= 2
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                          title: 'Photo',
                        ),
                        EasyStep(
                          customStep: Icon(
                            Icons.check_circle_outline,
                            color: controller.currentStep.value >= 3
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                          title: 'Review',
                        ),
                      ],
                      onStepReached: (index) =>
                          controller.currentStep.value = index,
                      borderThickness: 2,
                      activeStepBorderColor: Colors.white,
                      activeStepIconColor: Colors.white,
                      finishedStepBorderColor: Colors.white,
                      finishedStepIconColor: Colors.white,
                      finishedStepTextColor: Colors.white,
                      activeStepTextColor: Colors.white,
                      internalPadding: 16,
                      showLoadingAnimation: false,
                    )),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Obx(() => _buildCurrentStep(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context) {
    switch (controller.currentStep.value) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildLocationStep();
      case 2:
        return _buildProfilePhotoStep();
      case 3:
        return _buildReviewStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Form(
      key: controller.personalInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: controller.firstnameController,
            label: 'First Name',
            icon: Icons.person_outline,
            validator: (value) =>
                value?.isEmpty ?? true ? 'First name required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: controller.lastnameController,
            label: 'Last Name',
            icon: Icons.person_outline,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Last name required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: controller.contactInfoController,
            label: 'Contact Info',
            icon: Icons.phone_outlined,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Contact info required' : null,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.nextStep,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return Form(
      key: controller.locationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Location',
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          CSCPickerPlus(
            showCities: true,
            showStates: true,
            onCountryChanged: (value) => controller.setCountry(value),
            onStateChanged: (value) => controller.setState(value),
            onCityChanged: (value) => controller.setCity(value),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Set Precise Location'),
            subtitle: Text(controller.address.value),
            trailing: IconButton(
              icon: const Icon(Icons.map_outlined),
              onPressed: controller.setCurrentLocation,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.nextStep,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildProfilePhotoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Photo',
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Stack(
            children: [
              Obx(() => CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: controller.selectedImage.value != null
                        ? FileImage(controller.selectedImage.value!)
                        : null,
                    child: controller.selectedImage.value == null
                        ? const Icon(Icons.person_outline, size: 80)
                        : null,
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: controller.getImage,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Add a profile photo to help others recognize you',
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.previousStep,
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.nextStep,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }

Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Your Profile',
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: controller.selectedImage.value != null
                ? FileImage(controller.selectedImage.value!)
                : null,
          ),
          title: Text('${controller.firstname} ${controller.lastname}'),
          subtitle: Text(controller.contactInfo.value),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text('${controller.city}, ${controller.state}'),
          subtitle: Text(controller.country.value),
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.previousStep,
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() => ElevatedButton(
                    onPressed: controller.status.value == Status.loading
                        ? null
                        : controller.saveProfile,
                    child: controller.status.value == Status.loading
                        ? const CircularProgressIndicator()
                        : const Text('Complete Setup'),
                  )),
          ),
          ],
        ),
      ],
    );
  }

}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
