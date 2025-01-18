import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'change_password_controller.dart';

class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: controller.currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => 
                    value?.isEmpty ?? true ? 'Current password required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'New password required';
                  if (value!.length < 8) return 'Password must be at least 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Confirm password required';
                  if (value != controller.newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value 
                        ? null 
                        : controller.changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary)
                        : Text(
                            'Change Password',
                            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSecondary),
                          ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
