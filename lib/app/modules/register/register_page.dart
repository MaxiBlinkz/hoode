import 'dart:async';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/widgets/social_button.dart';
import 'package:hoode/app/data/enums/custom_pass_strength.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/profile_setup/profile_setup_page.dart';
import 'package:iconly/iconly.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import '../../core/theme/colors.dart';
import 'register_controller.dart';
import 'package:customisable_stepper/customisable_stepper.dart';

class RegisterPage extends GetView<RegisterController> {
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    const config = PasswordGeneratorConfiguration(
      length: 32,
      minUppercase: 8,
      minSpecial: 8,
    );

    final passwordGenerator = PasswordGenerator.fromConfig(
      configuration: config,
    );

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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Hoode",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: controller.nameController,
                            decoration: InputDecoration(
                              hintText: "Username",
                              prefixIcon: const Icon(IconlyLight.profile,
                                  color: AppColors.primary),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: controller.emailController,
                            decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: const Icon(IconlyLight.message,
                                  color: AppColors.primary),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!GetUtils.isEmail(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Obx(() => TextFormField(
                            controller: controller.passwordController,
                            obscureText: !controller.isPasswordVisible.value,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: const Icon(IconlyLight.lock,
                                  color: AppColors.primary),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      controller.isPasswordVisible.value
                                          ? IconlyLight.hide
                                          : IconlyLight.show,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: controller.togglePasswordVisibility,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      IconlyLight.star,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () {
                                      final password = passwordGenerator.generate();
                                      controller.passwordController.text = password;
                                      controller.confirmPasswordController.text = password;
                                    },
                                  ),
                                ],
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          )),
                          const SizedBox(height: 20),
                          Obx(() => TextFormField(
                            controller: controller.confirmPasswordController,
                            obscureText: !controller.isPasswordVisible.value,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              prefixIcon: const Icon(IconlyLight.lock,
                                  color: AppColors.primary),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != controller.passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          )),
                          const SizedBox(height: 30),
                          EasyButton(
                            buttonColor: AppColors.primary,
                            borderRadius: 36,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                controller.register();
                              }
                            },
                            idleStateWidget: const Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                            loadingStateWidget: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigate to login page
                      Get.toNamed('/login');
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // Auth2
                  const SizedBox(height: 20),
                  const Text(
                    "Or continue with",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialButton(
                        icon: 'assets/icons/google.png',
                        onPressed: () {
                          // Implement Google login
                        },
                      ),
                      const SizedBox(width: 20),
                      SocialButton(
                        icon: 'assets/icons/apple.png',
                        onPressed: () {
                          // Implement Apple login
                        },
                      ),
                      const SizedBox(width: 20),
                      SocialButton(
                        icon: 'assets/icons/facebook.png',
                        onPressed: () {
                          // Implement Facebook login
                        },
                      ),
                    ],
                  ),

                  // Auth2 End
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showNavigationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Account Created"),
          content: const Text(
              "Your account has been successfully created. Would you like to set up your profile now?"),
          actions: [
            TextButton(
              child: const Text("Set Up Profile"),
              onPressed: () {
                Get.offAll(() => ProfileSetupPage());
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }
}
