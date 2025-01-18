import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import '../../core/widgets/social_button.dart';
import '../../core/theme/colors.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginFormKey = GlobalKey<FormState>();

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
                    key: loginFormKey,
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
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? IconlyLight.hide
                                        : IconlyLight.show,
                                    color: AppColors.primary,
                                  ),
                                  onPressed:
                                      controller.togglePasswordVisibility,
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
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            )),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Obx(() => Checkbox(
                                  value: controller.rememberMe.value,
                                  onChanged: controller.toggleRememberMe,
                                  activeColor: AppColors.primary,
                                )),
                            const Text(
                              'Remember Me',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        EasyButton(
                            buttonColor: AppColors.primary,
                            borderRadius: 36,
                          onPressed: () {
                            if (loginFormKey.currentState!.validate()) {
                              controller.login();
                            }
                            },
                            idleStateWidget: const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          loadingStateWidget: const CircularProgressIndicator(
                              color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
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
                // // ################## Banner ad at bottom ########################
                // const SizedBox(height: 20),
                // adService.bannerAd != null
                //     ? SizedBox(
                //         width: adService.bannerAd!.size.width.toDouble(),
                //         height: adService.bannerAd!.size.height.toDouble(),
                //         child: AdWidget(ad: adService.bannerAd!),
                //       )
                //     : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
