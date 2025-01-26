import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/enums/enums.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:toastification/toastification.dart';
import '../../data/services/db_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final logger = Logger(printer: PrettyPrinter());
  final notify = Toastification();

    final GoogleSignIn _googleSignIn = GoogleSignIn();

  var name = "".obs;
  var email = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;
  var isRegistered = false.obs;
  var hidePassword = false.obs;
  var hideConfirmPassword = false.obs;

  var id = "".obs;
  var status = Status.initial.obs;
  var err = "".obs;

  late final PocketBase pb;
  final storage = GetStorage();

  @override
  Future<void> onInit() async {
    super.onInit();
    initControllers();
    String url = await DbHelper.getPocketbaseUrl();
    pb = PocketBase(url);
  }

  Future<void> register() async {
    status(Status.loading);
    isRegistered(false);
    final body = <String, dynamic>{
      "username": name.value,
      "email": email.value,
      "emailVisibility": true,
      "password": password.value,
      "passwordConfirm": confirmPassword.value,
    };
    try {
      final record = await pb.collection('users').create(body: body);
      id(record.id);
      status(Status.success);
    } catch (e) {
      status(Status.error);
      err.value = e.toString();
            Get.snackbar("Error", '$e', backgroundColor: Colors.red);
      logger.e('$e');
    } finally {
      if (status == Status.success) {
        final authData = await pb.collection('users').authWithPassword(
              email.value,
              password.value,
            );
        storage.write('token', authData.token);
      }
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

   Future<void> googleSignUp() async {
    status(Status.loading);
    try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Use the correct PocketBase OAuth2 authentication method
        final authData = await pb.collection('users').authWithOAuth2(
          'google',
          (url) async {
            await launchUrl(url);
          },
           createData: {
           'email': googleUser.email,
           'emailVisibility': true,
         },
        );

          if (pb.authStore.isValid) {
          status(Status.success);
            storage.write('token', authData.token);
           Get.offAllNamed('/profile-setup', arguments: {'id': authData.record?.id});
        }
    } catch (e) {
      status(Status.error);
      err.value = e.toString();
      logger.e('Google Sign In Error: ${err.value}');
    }
      update();
  }

  void initControllers() {
    nameController.addListener(() => name.value = nameController.text);
    emailController.addListener(() => email.value = emailController.text);
    passwordController
        .addListener(() => password.value = passwordController.text);
    confirmPasswordController.addListener(
        () => confirmPassword.value = confirmPasswordController.text);
  }


  @override
  void onReady() {
    super.onReady();
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