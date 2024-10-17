import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/profile_setup/profile_setup_page.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/widgets.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final Logger logger = Logger(printer: PrettyPrinter());

  var name = "".obs;
  var email = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;
  var isRegistered = false.obs;

  var id = "";
  var status = Status.pending.obs;

  final pb = PocketBase(POCKETBASE_URL_ANDROID);
  //final pb = POCKETBASE;

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
      id = record.id;
      if(pb.authStore.isValid){
        status(Status.success);
      } else {
        status(Status.pending);
      }
    } catch (e) {
      status(Status.error);
      logger.i('\n\n${status.value}\n\n');
      logger.e('\n\n${e}\n\n');
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
