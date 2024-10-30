import 'dart:async';
import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/widgets/social_button.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../core/theme/colors.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = controller.emailController;
      final passwordController = controller.passwordController;
      final _formKey = GlobalKey<FormState>();
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
                  // Logo
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
                  // Login Form
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
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                          // Email Field
                          FormBuilderTextField(
                              name: "Email",
                              controller: emailController,
                              obscureText: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email()
                              ])),
                          const SizedBox(height: 20),
                          // Password Field
                          Obx(() {
                            return FormBuilderTextField(
                                name: "Password",
                                controller: passwordController,
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  prefixIcon: const Icon(IconlyLight.lock,
                                      color: AppColors.primary),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordVisible.value
                                          ? IconlyLight.hide
                                          : IconlyLight.show,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () {
                                      controller.togglePasswordVisibility();
                                    },
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          vertical: 15),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.password(),
                                ]));
                          }),
                          const SizedBox(height: 20),
                          // Login Button
                          ElevatedButton(
                            onPressed: () async {
                             controller.login();
                                await Future.delayed(Duration(
                                    seconds:
                                        2)); // Give time for the registration process
                                if (controller.status.value ==
                                    Status.success) {
                                  //[[[[[[[[[[[[[[[[[[[[[[[[[[Loading Bar Complete]]]]]]]]]]]]]]]]]]]]]]]]]]]]
                                  Get.snackbar(
                                    "Sign Up",
                                    "Account Created Succesfully",
                                  );
                                  Get.offAll(() => const NavBarPage());
                                } else if (controller.status.value ==
                                    Status.error) {
                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.error,
                                      title: "Login",
                                      text: "Error Logging In...");
                                }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              textStyle: const TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36),
                              ),
                            ),
                            child: const Text("Login"),
                          ),
                          const SizedBox(height: 20),
                          // Forgot Password Button
                          TextButton(
                            onPressed: () {
                              // Implement forgot password logic
                            },
                            child: const Text("Forgot Password?"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sign Up Button
                  TextButton(
                    onPressed: () {
                      // Navigate to sign up page
                      Get.toNamed('/register');
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Social Login Text
                  const Text(
                  "Or continue with",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  // Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialButton(
                        icon: 'assets/icons/google.png',
                        onPressed: () {
                          // Implement Google login
                          controller.googleSignIn();
                        },
                      ),
                      const SizedBox(width: 20),
                      SocialButton(
                        icon: 'assets/icons/apple.png',
                        onPressed: () {
                          // Implement Apple login
                          controller.appleSignIn();
                        },
                      ),
                      const SizedBox(width: 20),
                      SocialButton(
                        icon: 'assets/icons/facebook.png',
                        onPressed: () {
                          // Implement Facebook login
                          controller.facebookSignIn();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ));

  }
}
