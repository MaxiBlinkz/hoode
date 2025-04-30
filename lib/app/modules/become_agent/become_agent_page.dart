import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'become_agent_controller.dart';

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
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      'Become an Agent',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Stepper
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              
              // Main Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
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
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    
                    return Form(
                      key: controller.agentFormKey,
                      child: _buildCurrentStep(context),
                    );
                  }),
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
        return _buildBasicInfoStep(context);
      case 1:
        return _buildProfessionalDetailsStep(context);
      case 2:
        return _buildSpecializationsStep(context);
      case 3:
        return _buildReviewStep(context);
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Basic Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Let\'s start with some basic information about you',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
                    // Profile Image
          Center(
            child: Obx(() => GestureDetector(
              onTap: controller.pickProfileImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: controller.profileImage.value != null
                        ? FileImage(controller.profileImage.value!)
                        : null,
                    child: controller.profileImage.value == null
                        ? const Icon(
                            IconlyBold.camera,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ),
          const SizedBox(height: 24),
          
          // Name Field
          TextFormField(
            controller: controller.nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: const Icon(IconlyLight.profile),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Title Field
          TextFormField(
            controller: controller.titleController,
            decoration: InputDecoration(
              labelText: 'Professional Title',
              hintText: 'e.g. Senior Real Estate Agent',
              prefixIcon: const Icon(IconlyLight.work),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your professional title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Contact Field
          TextFormField(
            controller: controller.contactController,
            decoration: InputDecoration(
              labelText: 'Contact Number',
              prefixIcon: const Icon(IconlyLight.call),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your contact number';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          
          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: controller.nextStep,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalDetailsStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Professional Details',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us about your professional background',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // License Field
          TextFormField(
            controller: controller.licenseController,
            decoration: InputDecoration(
              labelText: 'License Number',
              prefixIcon: const Icon(IconlyLight.document),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your license number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Experience Field
          TextFormField(
            controller: controller.experienceController,
            decoration: InputDecoration(
              labelText: 'Years of Experience',
              prefixIcon: const Icon(IconlyLight.time_circle),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your years of experience';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Website Field
          TextFormField(
            controller: controller.websiteController,
            decoration: InputDecoration(
              labelText: 'Website (Optional)',
              hintText: 'https://yourwebsite.com',
              prefixIcon: const Icon(Icons.link),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Bio Field
          TextFormField(
            controller: controller.bioController,
            decoration: InputDecoration(
              labelText: 'Professional Bio',
              hintText: 'Tell clients about yourself and your expertise',
              prefixIcon: const Icon(IconlyLight.edit),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              alignLabelWithHint: true,
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your professional bio';
              }
              if (value.length < 50) {
                return 'Bio should be at least 50 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          
          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: controller.previousStep,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
              ElevatedButton.icon(
                onPressed: controller.nextStep,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationsStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Areas of Expertise',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select your specializations and add certifications',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Specializations
          Text(
            'Specializations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.specializations.map((spec) {
              final isSelected = controller.selectedSpecializations.contains(spec);
              return FilterChip(
                label: Text(spec),
                selected: isSelected,
                onSelected: (_) => controller.toggleSpecialization(spec),
                backgroundColor: Colors.grey[200],
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                checkmarkColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: isSelected 
                      ? Theme.of(context).primaryColor 
                      : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          )),
          const SizedBox(height: 24),
          
          // Certifications
          Text(
            'Certifications & Awards',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.certificationController,
                  decoration: InputDecoration(
                    hintText: 'Add certification or award',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: controller.addCertification,
                icon: const Icon(Icons.add_circle),
                color: Theme.of(context).primaryColor,
                iconSize: 36,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => controller.certifications.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No certifications added yet',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.certifications.length,
                  itemBuilder: (context, index) {
                    final cert = controller.certifications[index];
                    return ListTile(
                      leading: const Icon(IconlyBold.shield_done),
                      title: Text(cert),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.removeCertification(cert),
                      ),
                    );
                  },
                ),
          ),
          const SizedBox(height: 32),
          
          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: controller.previousStep,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
              ElevatedButton.icon(
                onPressed: controller.nextStep,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Review Your Application',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please review your information before submitting',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Profile Preview
          Center(
            child: Column(
              children: [
                Obx(() => CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: controller.profileImage.value != null
                      ? FileImage(controller.profileImage.value!)
                      : null,
                  child: controller.profileImage.value == null
                      ? const Icon(
                          IconlyBold.profile,
                          size: 40,
                          color: Colors.grey,
                        )
                      : null,
                )),
                const SizedBox(height: 16),
                Text(
                  controller.nameController.text,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  controller.titleController.text,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Information Review
          _buildReviewSection(
            context,
            'Basic Information',
            [
              _buildReviewItem('Name', controller.nameController.text),
              _buildReviewItem('Title', controller.titleController.text),
              _buildReviewItem('Contact', controller.contactController.text),
            ],
          ),
          
          _buildReviewSection(
            context,
            'Professional Details',
            [
              _buildReviewItem('License', controller.licenseController.text),
              _buildReviewItem('Experience', '${controller.experienceController.text} years'),
              if (controller.websiteController.text.isNotEmpty)
                _buildReviewItem('Website', controller.websiteController.text),
              _buildReviewItem('Bio', controller.bioController.text, isMultiLine: true),
            ],
          ),
          
          _buildReviewSection(
            context,
            'Specializations',
            [
                            _buildReviewItem(
                'Areas of Expertise', 
                controller.selectedSpecializations.join(', '),
                isMultiLine: true,
              ),
            ],
          ),
          
          if (controller.certifications.isNotEmpty)
            _buildReviewSection(
              context,
              'Certifications & Awards',
              controller.certifications.map((cert) => 
                _buildReviewItem('', '• $cert')
              ).toList(),
            ),
          
          const SizedBox(height: 32),
          
          // Terms and Conditions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms & Conditions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'By submitting this application, you confirm that all information provided is accurate and complete. You agree to abide by our platform\'s guidelines for real estate agents.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: controller.previousStep,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
              Obx(() => ElevatedButton.icon(
                onPressed: controller.isSubmitting.value 
                    ? null 
                    : controller.submitAgentApplication,
                icon: controller.isSubmitting.value 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle),
                label: Text(
                  controller.isSubmitting.value ? 'Submitting...' : 'Submit Application'
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildReviewSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getSectionIcon(title),
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        ...items,
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildReviewItem(String label, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (label.isNotEmpty) ...[
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getSectionIcon(String title) {
    switch (title) {
      case 'Basic Information':
        return IconlyBold.profile;
      case 'Professional Details':
        return IconlyBold.work;
      case 'Specializations':
        return IconlyBold.star;
      case 'Certifications & Awards':
        return IconlyBold.shield_done;
      default:
        return IconlyBold.document;
    }
  }
}
