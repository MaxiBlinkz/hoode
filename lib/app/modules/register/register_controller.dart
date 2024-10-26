import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/profile_setup/profile_setup_page.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart' as bugnag;

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
  var isPasswordVisible = false.obs;

  var id = "".obs;
  var status = Status.pending.obs;
  var err = "".obs;

  final pb = PocketBase(POCKETBASE_URL);
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
      id(record.id);
      status(Status.success);
    } catch (e, stack) {
      status(Status.error);
      err.value = e.toString();
      notify.show(
          type: ToastificationType.error,
          description: Text(e.toString()),
          title: const Text('error'),
          autoCloseDuration: const Duration(microseconds: 500));
      logger.i('${status.value}');
      logger.e('$e');
      await bugnag.bugsnag.notify(e, stack);
    }
    update();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
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
