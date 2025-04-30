import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/enums/enums.dart';
import '../../data/services/authservice.dart';
import 'package:logger/logger.dart';

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

  @override
  void onInit() {
    super.onInit();
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

  void togglePasswordVisibility() {
    hidePassword.toggle();
    update();
  }

  void toggleConfirmPasswordVisibility() {
    hideConfirmPassword.toggle();
    update();
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
