import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/theme.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../../core/widgets/social_button.dart';
import '../profile_setup/profile_setup_page.dart';
import 'package:iconly/iconly.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
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
                    const SizedBox(height: 20),
                    // Using Supabase Auth UI Email Field for Registration
                    SupaEmailAuth(
                      redirectTo: controller.redirectUrl,
                      onSignInComplete: controller.onSignInComplete,
                      onSignUpComplete: controller.onSignUpComplete,
                      onError: controller.onAuthError,
                      metadataFields: [
                        MetaDataField(
                          key: 'username',
                          label: 'Username',
                          prefixIcon: Icon(IconlyLight.profile, color: Colors.grey.shade500),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                      ],
                      isInitiallySigningIn: false, // Start with sign up form
                      showConfirmPasswordField: true,
                      prefixIconEmail: Icon(IconlyLight.message, color: Colors.grey.shade500),
                      prefixIconPassword: Icon(IconlyLight.lock, color: Colors.grey.shade500),
                      localization: SupaEmailAuthLocalization(
                        enterEmail: "Email",
                        enterPassword: "Password",
                        signIn: "Sign In",
                        signUp: "Sign Up",
                        forgotPassword: "Forgot Password?",
                        dontHaveAccount: "Don't have an account? Sign up",
                        haveAccount: "Already have an account? Sign in",
                        validEmailError: "Please enter a valid email address",
                        passwordLengthError: "Password must be at least 6 characters",
                        requiredFieldError: "This field is required",
                        confirmPassword: "Confirm Password",
                        confirmPasswordError: "Passwords do not match",
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
                            controller.googleSignUp();
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
}
