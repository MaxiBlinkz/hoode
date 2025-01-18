import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:logger/logger.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../core/theme/colors.dart';

import 'become_agent_controller.dart';

import 'package:easy_stepper/easy_stepper.dart';

class BecomeAgentPage extends GetView<BecomeAgentController> {
  const BecomeAgentPage({super.key});

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
                        IconlyBold.profile,
                        color: controller.currentStep.value >= 0 
                            ? Colors.white 
                            : Colors.white.withOpacity(0.5),
                      ),
                      title: 'Basic Info',
                    ),
                    EasyStep(
                      customStep: Icon(
                        IconlyBold.work,
                        color: controller.currentStep.value >= 1 
                            ? Colors.white 
                            : Colors.white.withOpacity(0.5),
                      ),
                      title: 'Professional',
                    ),
                    EasyStep(
                      customStep: Icon(
                        IconlyBold.star,
                        color: controller.currentStep.value >= 2 
                            ? Colors.white 
                            : Colors.white.withOpacity(0.5),
                      ),
                      title: 'Expertise',
                    ),
                    EasyStep(
                      customStep: Icon(
                        IconlyBold.tick_square,
                        color: controller.currentStep.value >= 3 
                            ? Colors.white 
                            : Colors.white.withOpacity(0.5),
                      ),
                      title: 'Review',
                    ),
                  ],
                  onStepReached: (index) => controller.currentStep.value = index,
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
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: controller.agentFormKey,
                    child: Obx(() => _buildCurrentStep()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (controller.currentStep.value) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildProfessionalDetailsStep();
      case 2:
        return _buildSpecializationsStep();
      case 3:
        return _buildReviewStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: controller.nameController,
            label: 'Full Name',
            icon: IconlyLight.profile,
            validator: (value) => value?.isEmpty ?? true ? 'Name required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: controller.titleController,
            label: 'Professional Title',
            icon: IconlyLight.work,
            validator: (value) => value?.isEmpty ?? true ? 'Title required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: controller.contactController,
            label: 'Contact Information',
            icon: IconlyLight.call,
            validator: (value) => value?.isEmpty ?? true ? 'Contact required' : null,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.nextStep,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildProfessionalDetailsStep() {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Professional Details',
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: controller.licenseController,
          label: 'License Number',
          icon: IconlyLight.document,
          validator: (value) => value?.isEmpty ?? true ? 'License required' : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.experienceController,
          label: 'Years of Experience',
          icon: Icons.timer,
          validator: (value) => value?.isEmpty ?? true ? 'Experience required' : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.bioController,
          label: 'Professional Bio',
          icon: IconlyLight.paper,
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Bio required' : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.websiteController,
          label: 'Website (Optional)',
          icon: Icons.link,
        ),
        const SizedBox(height: 32),
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

Widget _buildSpecializationsStep() {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Areas of Expertise',
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Select your specializations:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.specializations.map((spec) {
            return FilterChip(
              label: Text(spec),
              selected: controller.selectedSpecializations.contains(spec),
              onSelected: (_) => controller.toggleSpecialization(spec),
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        )),
        const SizedBox(height: 32),
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

Widget _buildReviewStep() {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Your Profile',
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildReviewTile('Name', controller.nameController.text, IconlyLight.profile),
        _buildReviewTile('Title', controller.titleController.text, IconlyLight.work),
        _buildReviewTile('License', controller.licenseController.text, IconlyLight.document),
        _buildReviewTile('Experience', controller.experienceController.text, IconlyLight.time_circle),
        const Divider(height: 32),
        Text(
          'Specializations',
          style: Get.textTheme.titleMedium,
        ),
        Wrap(
          spacing: 8,
          children: controller.selectedSpecializations.map((spec) => Chip(
            label: Text(spec),
            backgroundColor: AppColors.primary.withOpacity(0.1),
          )).toList(),
        ),
        const SizedBox(height: 32),
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
                onPressed: controller.isLoading.value 
                    ? null 
                    : controller.submitAgentApplication,
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit Application'),
              )),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildReviewTile(String title, String value, IconData icon) {
  return ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(title),
    subtitle: Text(value),
    dense: true,
  );
}

}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final int? maxLines;

  const CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.maxLines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
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
