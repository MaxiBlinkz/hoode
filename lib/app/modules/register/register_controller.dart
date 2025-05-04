import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/enums/enums.dart';
import '../../data/services/authservice.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../profile_setup/profile_setup_page.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final logger = Logger(printer: PrettyPrinter());

  var hidePassword = false.obs;
  var hideConfirmPassword = false.obs;
  var status = Status.initial.obs;
  var err = "".obs;

  final authService = Get.find<AuthService>();
  
  // Supabase redirect URL - replace with your app's URL scheme
  final String redirectUrl = 'io.supabase.hoode://signup-callback/';

  @override
  void onInit() {
    super.onInit();
  }

  // Callback for Supabase Auth sign in success
  void onSignInComplete(AuthResponse response) {
    status(Status.success);
    logger.i('User signed in: ${response.user?.email}');
    Get.offAllNamed('/home');
  }

  // Callback for Supabase Auth sign up success
  void onSignUpComplete(AuthResponse response) {
    status(Status.success);
    logger.i('User signed up: ${response.user?.email}');
    
    // Show dialog to set up profile
    if (Get.context != null) {
      showNavigationDialog(Get.context!);
    } else {
      Get.offAll(() => ProfileSetupPage());
    }
  }

  // Callback for Supabase Auth errors
  void onAuthError(Object error) {
    status(Status.error);
    err.value = error.toString();
    logger.e('Auth error: ${err.value}');
    Get.snackbar(
      'Registration Error',
      err.value.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
      colorText: Get.theme.colorScheme.onError,
    );
  }

  Future<void> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      err.value = "Passwords do not match";
      status(Status.error);
      return;
    }
    
    status(Status.loading);
    try {
      await authService.signUpWithEmail(
        emailController.text,
        passwordController.text,
        nameController.text,
      );
      status(Status.success);
    } catch (e) {
      err.value = e.toString();
      status(Status.error);
      logger.e('Register error: $e');
    }
    update();
  }

  Future<void> googleSignUp() async {
    status(Status.loading);
    try {
      await authService.signInWithGoogle();
      status(Status.success);
    } catch (e) {
      err.value = e.toString();
      status(Status.error);
      logger.e('Google Sign Up Error: ${err.value}');
    }
    update();
  }

  Future<void> facebookSignIn() async {
    status(Status.loading);
    try {
      await authService.signInWithFacebook();
      status(Status.success);
    } catch (e) {
      err.value = e.toString();
      status(Status.error);
      logger.e('Facebook Sign In Error: ${err.value}');
    }
    update();
  }

  void togglePasswordVisibility() {
    hidePassword.toggle();
    update();
  }

  void toggleConfirmPasswordVisibility() {
    hideConfirmPassword.toggle();
    update();
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

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
