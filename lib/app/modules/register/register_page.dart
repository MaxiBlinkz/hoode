import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                      key: regFormKey,
                      child: Column(
                        children: [
                          Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                        Text(
                            "Sign up to get started",
                           style: TextStyle(
                           fontSize: 14,
                            color: Colors.grey.shade500,
                           ),
                       ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: controller.nameController,
                            decoration: InputDecoration(
                              hintText: "Username",
                              prefixIcon: Icon(IconlyLight.profile,
                                  color: Theme.of(context).primaryColor),
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
                              prefixIcon: Icon(IconlyLight.message,
                                  color: Theme.of(context).primaryColor),
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
                                    color: Theme.of(context).primaryColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.hidePassword.value
                                        ? IconlyLight.hide
                                        : IconlyLight.show,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
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
                            obscureText:
                                  !controller.hideConfirmPassword.value,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                prefixIcon: Icon(IconlyLight.lock,
                                    color: Theme.of(context).primaryColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.hideConfirmPassword.value
                                        ? IconlyLight.hide
                                        : IconlyLight.show,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed:
                                      controller.toggleConfirmPasswordVisibility,
                                ),
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