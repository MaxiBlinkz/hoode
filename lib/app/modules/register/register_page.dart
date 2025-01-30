import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/theme.dart';
import '../../core/widgets/social_button.dart';
import '../profile_setup/profile_setup_page.dart';
import 'package:iconly/iconly.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final regFormKey = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
          // ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Welcome",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Sign up to get started",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Form(
                      key: regFormKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: controller.nameController,
                            decoration: InputDecoration(
                                hintText: "Username",
                                labelStyle:
                                    TextStyle(color: Colors.grey.shade200),
                                prefixIcon: Icon(IconlyLight.profile,
                                    color: Colors.grey.shade500),
                                border: inputBorder),
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
                              labelStyle: TextStyle(color: Colors.grey.shade200),
                              prefixIcon: Icon(IconlyLight.message,
                                  color: Colors.grey.shade500),
                              border: inputBorder,
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
                          TextFormField(
                            controller: controller.passwordController,
                            obscureText: !controller.hidePassword.value,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(IconlyLight.lock,
                                  color: Colors.grey.shade400),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.hidePassword.value
                                      ? IconlyLight.hide
                                      : IconlyLight.show,
                                  color: Colors.grey.shade400,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                              border: inputBorder,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: controller.confirmPasswordController,
                            obscureText: !controller.hideConfirmPassword.value,
                            decoration: InputDecoration(
                                hintText: "Confirm Password",
                                prefixIcon: Icon(IconlyLight.lock,
                                    color: Colors.grey.shade400),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.hideConfirmPassword.value
                                        ? IconlyLight.hide
                                        : IconlyLight.show,
                                    color: Colors.grey.shade400,
                                  ),
                                  onPressed:
                                      controller.toggleConfirmPasswordVisibility,
                                ),
                                border: inputBorder
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please confirm your password";
                              }
                              if (value != controller.passwordController.text) {
                                return "Password mismatch";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          EasyButton(
                            buttonColor: Theme.of(context).primaryColor,
                            borderRadius: 36,
                            onPressed: () {
                              if (regFormKey.currentState!.validate()) {
                                controller.register();
                              }
                            },
                            idleStateWidget: const Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                            loadingStateWidget: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                       TextButton(
                    onPressed: () {
                      // Navigate to sign up page
                      Get.toNamed('/login');
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
                  ],
                ),
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
}