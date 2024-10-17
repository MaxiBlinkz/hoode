import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/widgets/social_button.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/profile_setup/profile_setup_page.dart';
import 'package:iconly/iconly.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import '../../core/theme/colors.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = controller.nameController;
    final emailController = controller.emailController;
    final passwordController = controller.passwordController;
    final confirmPasswordController = controller.confirmPasswordController;

    final Logger logger = Logger(printer: PrettyPrinter());

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
                        _buildTextField(
                          controller: nameController,
                          hintText: "Username",
                          prefixIcon: IconlyLight.profile,
                        ),
                        const SizedBox(height: 20),
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
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email()
                            ])),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                            name: "Password",
                            controller: passwordController,
                            obscureText: controller.isPasswordVisible.value,
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
                                  const EdgeInsets.symmetric(vertical: 15),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.password()
                            ])),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                            name: "Confirm Password",
                            controller: confirmPasswordController,
                            obscureText: controller.isPasswordVisible.value,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
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
                                  controller.togglePasswordVisibility;
                                },
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
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.password()
                            ])),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            //if (await InternetConnection().hasInternetAccess) {
                              controller.register();
                              // if (controller.status.value == Status.loading) {
                              //   CoolAlert.show(
                              //       context: context,
                              //       type: CoolAlertType.loading,
                              //       title: "Sign Up",
                              //       text: "Creating Account");
                              // }
                              await Future.delayed(Duration(
                                  seconds:
                                      2)); // Give time for the registration process
                              if (controller.status.value == Status.success) {
                                // CoolAlert.show(
                                //     context: context,
                                //     type: CoolAlertType.success,
                                //     title: "Sign Up",
                                //     text: "Account Created");
                                Get.offAll(() => ProfileSetupPage());
                              } else if (controller.status.value ==
                                  Status.error) {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    title: "Sign Up",
                                    text: "Error Creating Account");
                              }
                            // } 
                            // else {
                            //   CoolAlert.show(
                            //       context: context,
                            //       type: CoolAlertType.error,
                            //       title: "Ooops!!!",
                            //       text: "No Internet Connection!");
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Register"),
                        ),
                      ],
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
                    "Or login with",
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
