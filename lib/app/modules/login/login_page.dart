import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/enums/enums.dart';
import '../../core/widgets/social_button.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo or App Name
                    const Text(
                      "Hoode",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Login Form Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Sign in to continue",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Email Field
                            TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(IconlyLight.message, color: Theme.of(context).primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
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
                            // Password Field
                            Obx(() => TextFormField(
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(IconlyLight.lock, color: Theme.of(context).primaryColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value ? IconlyLight.show : IconlyLight.hide,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
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
                            const SizedBox(height: 12),
                            // Remember Me & Forgot Password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Obx(() => Checkbox(
                                      value: controller.rememberMe.value,
                                      onChanged: controller.toggleRememberMe,
                                      activeColor: Theme.of(context).primaryColor,
                                    )),
                                    Text("Remember me",
                                        style: TextStyle(color: Colors.grey.shade700)),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle forgot password
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Obx(() => ElevatedButton(
                                onPressed: controller.status.value == Status.loading
                                    ? null
                                    : () => controller.login(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: controller.status.value == Status.loading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Social Login Section
                    Text(
                      "Or continue with",
                      style: TextStyle(color: Colors.grey.shade300),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialButton(
                          icon: 'assets/icons/google.png',
                          onPressed: () => controller.googleSignIn(),
                        ),
                        const SizedBox(width: 20),
                        SocialButton(
                          icon: 'assets/icons/facebook.png',
                          onPressed: () => controller.facebookSignIn(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Sign Up Link
                    TextButton(
                      onPressed: () => Get.toNamed('/register'),
                      child: const Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(color: Colors.white),
                      ),
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
}
