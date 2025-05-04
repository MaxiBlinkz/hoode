import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/enums/enums.dart';
import '../../data/services/authservice.dart';
import 'package:logger/logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Logger logger = Logger(printer: PrettyPrinter());
  
  var status = Status.initial.obs;
  Rx<Object> err = "".obs;
  var isPasswordVisible = false.obs;
  final rememberMe = false.obs;

  BannerAd? bannerAd;
  bool isAdLoaded = false;

  final authService = Get.find<AuthService>();
  
  // Supabase redirect URL - replace with your app's URL scheme
  final String redirectUrl = 'io.supabase.hoode://login-callback/';

  @override
  void onInit() {
    super.onInit();
    loadCredentials();
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
    Get.offAllNamed('/home');
  }

  // Callback for Supabase Auth errors
  void onAuthError(Object error) {
    status(Status.error);
    err.value = error.toString();
    logger.e('Auth error: ${err.value}');
    Get.snackbar(
      'Authentication Error',
      err.value.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
      colorText: Get.theme.colorScheme.onError,
    );
  }

  Future<void> login() async {
    status(Status.loading);
    try {
      await authService.signInWithEmail(
        emailController.text,
        passwordController.text,
        rememberMe: rememberMe.value,
      );
      status(Status.success);
    } catch (e) {
      err.value = e.toString();
      status(Status.error);
      logger.e('Login error: ${err.value}');
    }
    update();
  }

  Future<void> googleSignIn() async {
    status(Status.loading);
    try {
      await authService.signInWithGoogle();
      status(Status.success);
    } catch (e) {
      err.value = e.toString();
      status(Status.error);
      logger.e('Google Sign In Error: ${err.value}');
    }
    update();
  }

  // Future<void> appleSignIn() async {
  //   status(Status.loading);
  //   try {
  //     await authService.signInWithApple();
  //     status(Status.success);
  //   } catch (e) {
  //     err.value = e.toString();
  //     status(Status.error);
  //     logger.e('Apple Sign In Error: ${err.value}');
  //   }
  //   update();
  // }

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

  void loadCredentials() {
    final credentials = authService.getRememberedCredentials();
    if (credentials != null) {
      emailController.text = credentials['email']!;
      passwordController.text = credentials['password']!;
      rememberMe.value = true;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update();
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
    update();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
