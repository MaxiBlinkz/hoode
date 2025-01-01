import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../core/theme/colors.dart';

import 'become_agent_controller.dart';

class BecomeAgentPage extends GetView<BecomeAgentController> {
  const BecomeAgentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final agentFormKey = GlobalKey<FormState>();
    Logger logger = Logger();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become an Agent'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: agentFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Complete Your Agent Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                      labelText: 'Professional Title',
                      border: OutlineInputBorder(),
                      hintText: 'e.g. Senior Real Estate Agent',
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.bioController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                      hintText: 'Tell us about your experience...',
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Bio is required' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Specializations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.specializations
                            .map((spec) => FilterChip(
                                  label: Text(spec),
                                  selected: controller.selectedSpecializations
                                      .contains(spec),
                                  selectedColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  checkmarkColor:
                                      Theme.of(context).colorScheme.primary,
                                  onSelected: (selected) =>
                                      controller.toggleSpecialization(spec),
                                ))
                            .toList(),
                      )),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.licenseController,
                    decoration: const InputDecoration(
                      labelText: 'License Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'License is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.contactController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Information',
                      border: OutlineInputBorder(),
                      hintText: 'Phone number or additional contact details',
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Contact info is required'
                        : null,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (!agentFormKey.currentState!.validate()) {
                              Get.snackbar(
                                'Error',
                                'Please fill all required fields',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            } else if (agentFormKey.currentState == null) {
                              logger.e('Form not initialized properly');
                            } else {
                              controller.submitAgentApplication();
                            }
                          },
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Submit Application',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        )),
                  ),
                ],
              ),
            )
          
        ),
      ),
    );
  }
}
