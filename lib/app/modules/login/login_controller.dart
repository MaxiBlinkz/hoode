import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/data/services/adservice.dart';
import 'package:hoode/app/modules/home/home_page.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:bugsnag_flutter/bugsnag_flutter.dart' as bugnag;

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

  BannerAd? bannerAd;
  bool isAdLoaded = false;

  final storage = GetStorage();

  // final pb = POCKETBASE;
  final pb = PocketBase(POCKETBASE_URL);

  Future<void> login() async {
    status(Status.loading);
    isLoggedIn(false);
    try {
      final authData = await pb.collection('users').authWithPassword(
            email.value,
            password.value,
          );
      if (pb.authStore.isValid) {
        status(Status.success);
        storage.write('token', authData.token);
      } else {
        status(Status.pending);
      }
    } catch (e) {
      err.value = e.toString();
      status(Status.error);
      logger.i('${status.value}');
      logger.e('${err.value}');
      // await bugnag.bugsnag.notify(e, stack);
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
    } catch (e) {
      status(Status.error);
      logger.e(e);
      // await bugnag.bugsnag.notify(e, stack);
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
    } catch (e) {
      status(Status.error);
      logger.e(e);
      // await bugnag.bugsnag.notify(e, stack);
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

  void loadBannerAd() {
    bannerAd = AdService.createBannerAd()..load();
  }

  @override
  void onInit() {
    super.onInit();
    initControllers();
    loadBannerAd();
    AdService.loadInterstitialAd();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    bannerAd?.dispose();
    AdService.interstitialAd?.dispose();
    super.onClose();
  }
}
