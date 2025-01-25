import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/enums/enums.dart';
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
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7)
            ],
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
        return _buildProfilePhotoStep(context);
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
            'Complete Your Profile',
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
              const SizedBox(height: 10),
                 Text(
                            "Help people discover you by adding your info",
                           style: TextStyle(
                           fontSize: 14,
                            color: Colors.grey.shade500,
                           ),
                       ),
          const SizedBox(height: 20),
              TextFormField(
            controller: controller.firstnameController,
             decoration: InputDecoration(
               hintText: "Full Name",
                  prefixIcon: Icon(Icons.person_outline,
                      color: Theme.of(Get.context!).primaryColor),
             ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Full name required' : null,
          ),
          const SizedBox(height: 16),
           TextFormField(
            controller: controller.lastnameController,
              decoration: InputDecoration(
              hintText: "Username",
                  prefixIcon: Icon(Icons.person_outline,
                      color: Theme.of(Get.context!).primaryColor)
             ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Username is required' : null,
          ),
          const SizedBox(height: 16),
           TextFormField(
            controller: controller.contactInfoController,
             decoration: InputDecoration(
              hintText: "Bio",
                  prefixIcon: Icon(Icons.info_outline,
                      color: Theme.of(Get.context!).primaryColor)
            ),
          ),
          const SizedBox(height: 16),
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
            'Complete Your Profile',
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
               const SizedBox(height: 10),
                 Text(
                            "Help people discover you by adding your info",
                           style: TextStyle(
                           fontSize: 14,
                            color: Colors.grey.shade500,
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
            title: const Text('Add Location'),
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

  Widget _buildProfilePhotoStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            Text(
            'Complete Your Profile',
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
               const SizedBox(height: 10),
                 Text(
                            "Help people discover you by adding your info",
                           style: TextStyle(
                           fontSize: 14,
                            color: Colors.grey.shade500,
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
                  backgroundColor: Theme.of(context).primaryColor,
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
        Text(
          'Add Photo',
          textAlign: TextAlign.center,
          style: TextStyle(
           fontSize: 14,
            color: Colors.grey.shade500,
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
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(
            'Complete Your Profile',
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
               const SizedBox(height: 10),
                 Text(
                            "Help people discover you by adding your info",
                           style: TextStyle(
                           fontSize: 14,
                            color: Colors.grey.shade500,
                           ),
                       ),
            const SizedBox(height: 20),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: controller.selectedImage.value != null
                ? FileImage(controller.selectedImage.value!)
                : null,
          ),
          title: Text('${controller.firstname.value} ${controller.lastname.value}'),
            subtitle:  Text(controller.contactInfo.value),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text('${controller.city.value}, ${controller.state.value}'),
           subtitle: Text(controller.country.value),
        ),
            const Divider(),
                ListTile(
          leading: const Icon(Icons.location_on),
          title: Text('Location'),
             subtitle: Text(controller.address.value),
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
                        : const Text('Save Profile'),
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
      ),
    );
  }
}