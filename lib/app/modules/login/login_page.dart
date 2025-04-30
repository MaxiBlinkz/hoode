import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../../core/widgets/social_button.dart';
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
          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
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
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Sign in to continue",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Using Supabase Auth UI Email Field
                      SupaEmailAuth(
                        redirectTo: controller.redirectUrl,
                        onSignInComplete: controller.onSignInComplete,
                        onSignUpComplete: controller.onSignUpComplete,
                        onError: controller.onAuthError,
                        metadataFields: [
                          MetaDataField(
                            key: 'username',
                            label: 'Username',
                            prefixIcon: Icon(IconlyLight.profile, color: Theme.of(context).primaryColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                        ],
                        isInitiallySigningIn: true,
                        prefixIconEmail: Icon(IconlyLight.message, color: Theme.of(context).primaryColor),
                        prefixIconPassword: Icon(IconlyLight.lock, color: Theme.of(context).primaryColor),
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
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Or continue with",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                // Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialButton(
                      icon: 'assets/icons/google.png',
                      onPressed: () {
                        controller.googleSignIn();
                      },
                    ),
                    const SizedBox(width: 20),
                    SocialButton(
                      icon: 'assets/icons/apple.png',
                      onPressed: () {
                        controller.appleSignIn();
                      },
                    ),
                    const SizedBox(width: 20),
                    SocialButton(
                      icon: 'assets/icons/facebook.png',
                      onPressed: () {
                        controller.facebookSignIn();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/register');
                  },
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
    ));
  }
}
