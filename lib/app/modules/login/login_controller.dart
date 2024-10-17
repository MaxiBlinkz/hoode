import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/home/home_page.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Logger logger = Logger(printer: PrettyPrinter());
  var email = "".obs;
  var password = "".obs;
  final isLoggedIn = false.obs;
  var status = Status.pending.obs;
  Rx<Object> err = "".obs;

  // final pb = POCKETBASE;
  final pb = PocketBase(POCKETBASE_URL);

  Future<void> login() async {
    status(Status.loading);
    isLoggedIn(false);
    try {
      await pb.collection('users').authWithPassword(
            email.value,
            password.value,
          );
      if (pb.authStore.isValid) {
        status(Status.success);
      } else {
        status(Status.pending);
      }
    } catch (e) {
      err.value = e;
      status(Status.error);
      logger.i('${status.value}');
      logger.e('${e.toString()}');
    }
    update();
  }

  Future<void> googleSignIn() async {
    isLoggedIn(false);
    try {
      await pb.collection('users').authWithOAuth2('google', (url) async {
        //await launchUrl(url);
      });
    } catch (e) {
      logger.e(e);
    } finally {
      isLoggedIn(true);
      Get.offAll(() => const HomePage());
    }
  }

  Future<void> appleSignIn() async {
    isLoggedIn(false);
    try {
      await pb.collection('users').authWithOAuth2('apple', (url) async {
        //await launchUrl(url);
      });
    } catch (e) {
      print(e);
    } finally {
      isLoggedIn(true);
      Get.offAll(() => const HomePage());
    }
  }

  Future<void> facebookSignIn() async {
    isLoggedIn(false);
    try {
      await pb.collection('users').authWithOAuth2('facebook', (url) async {
        //await launchUrl(url);
      });
    } catch (e) {
      print(e);
    } finally {
      isLoggedIn(true);
      Get.offAll(() => const HomePage());
    }
  }

  void initControllers() {
    emailController.addListener(() => email.value = emailController.text);
    passwordController
        .addListener(() => password.value = passwordController.text);
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
