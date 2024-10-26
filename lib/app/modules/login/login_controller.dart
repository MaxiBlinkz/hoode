import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/home/home_page.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart' as bugnag;

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Logger logger = Logger(printer: PrettyPrinter());
  var email = "".obs;
  var password = "".obs;
  final isLoggedIn = false.obs;
  var status = Status.pending.obs;
  Rx<Object> err = "".obs;
  var isPasswordVisible = false.obs;

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
    } catch (e, stack) {
      err.value = e.toString();
      status(Status.error);
      logger.i('${status.value}');
      logger.e('${err.value}');
      await bugnag.bugsnag.notify(e, stack);
    }
    update();
  }

  Future<void> googleSignIn() async {
    isLoggedIn(false);
    try {
      await pb.collection('users').authWithOAuth2('google', (url) async {
        await launchUrl(url);
        logger.i(url);
      });
    } catch (e, stack) {
      status(Status.error);
      logger.e(e);
      await bugnag.bugsnag.notify(e, stack);
    } finally {
      isLoggedIn(true);
      status(Status.success);
      Get.offAll(() => const NavBarPage());
    }
  }

  Future<void> appleSignIn() async {
    isLoggedIn(false);
    try {
      await pb.collection('users').authWithOAuth2('apple', (url) async {
        await launchUrl(url);
      });
    } catch (e, stack) {
      status(Status.error);
      logger.e(e);
      await bugnag.bugsnag.notify(e, stack);
    } finally {
      isLoggedIn(true);
      Get.offAll(() => const NavBarPage());
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


  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update();
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
