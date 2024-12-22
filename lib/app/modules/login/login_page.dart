import 'dart:async';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_builder_ui_kit/flutter_builder_ui_kit.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hoode/app/core/widgets/social_button.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/data/services/adservice.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../core/theme/colors.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});

  BannerAd? bannerAd;
  bool isAdLoaded = false;

  @override
  Widget build(BuildContext context) {
    final emailController = controller.emailController;
    final passwordController = controller.passwordController;
    //final btnController = Easy
    final formKey = GlobalKey<FormState>();
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
                    key: formKey,
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
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
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
                              obscureText: !controller.isPasswordVisible.value,
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
                                FormBuilderValidators.password(),
                              ]));
                        }),
                        const SizedBox(height: 20),
                        // Login Button
                        EasyButton(
                            buttonColor: AppColors.primary,
                            borderRadius: 36,
                            onPressed: () async {
                              AdService.interstitialAd?.show();
                              controller.login();
                              await Future.delayed(const Duration(seconds: 2));
                              if (controller.status.value == Status.success) {
                                // btnController.success();
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                Get.offAll(() => const NavBarPage());
                              } else if (controller.status.value ==
                                  Status.error) {
                                //btnController.error();
                                ToastOverlay.show(
                                  context: context,
                                  message: "Something went wrong",
                                  backgroundColor: Colors.red,
                                );
                              }
                            },
                            idleStateWidget: const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                            loadingStateWidget: CircularProgressIndicator(
                              color: Colors.white,
                            )),
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
                // ################## Banner ad at bottom ########################
                const SizedBox(height: 20),
                controller.bannerAd != null
                    ? SizedBox(
                        width: controller.bannerAd!.size.width.toDouble(),
                        height: controller.bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: controller.bannerAd!),
                      )
                    : const SizedBox(),

              ],
            ),
          ),
        ),
      ),
    ));
  }
}
