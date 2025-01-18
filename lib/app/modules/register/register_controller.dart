import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/enums/enums.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:toastification/toastification.dart';
import 'package:hoode/app/data/services/db_helper.dart';


class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final logger = Logger(printer: PrettyPrinter());
  final notify = Toastification();
  //final bugsnag = Bugsnag();

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

  final storage = GetStorage();

  final pb = PocketBase(DbHelper.getPocketbaseUrl());

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
      // await bugnag.bugsnag.notify(e, stack);
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

  void initControllers() {
    nameController.addListener(() => name.value = nameController.text);
    emailController.addListener(() => email.value = emailController.text);
    passwordController
        .addListener(() => password.value = passwordController.text);
    confirmPasswordController.addListener(
        () => confirmPassword.value = confirmPasswordController.text);
  }

  @override
  void onInit() {
    super.onInit();
    initControllers();
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
