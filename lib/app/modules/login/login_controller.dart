import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/config/constants.dart';
import '../../data/enums/enums.dart';
import '../../data/services/authservice.dart';
// import 'package:hoode/app/data/services/adservice.dart';
import 'package:hoode/app/modules/home/home_page.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:bugsnag_flutter/bugsnag_flutter.dart' as bugnag;
import 'package:hoode/app/data/services/db_helper.dart';


class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Logger logger = Logger(printer: PrettyPrinter());
  var email = "".obs;
  var password = "".obs;
  final isLoggedIn = false.obs;
  var status = Status.initial.obs;
  Rx<Object> err = "".obs;
  var isPasswordVisible = false.obs;
  final rememberMe = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  BannerAd? bannerAd;
  bool isAdLoaded = false;

  final storage = GetStorage();

  // final pb = PocketBase(POCKETBASE_URL);
  final pb = PocketBase(DbHelper.getPocketbaseUrl());
  final authService = Get.find<AuthService>();

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
        authService.saveAuthState(authData.token, authData.record);
        
        if (rememberMe.value) {
          storage.write('rememberedEmail', email.value);
          storage.write('rememberedPassword', password.value);
        } else {
          storage.remove('rememberedEmail');
          storage.remove('rememberedPassword');
        }

        Get.offAll(() => const NavBarPage());
      } else {
        status(Status.initial);
      }
    } catch (e) {
      err.value = e.toString();
      status(Status.error);
      logger.i('${status.value}');
      logger.e('${err.value}');
    } 
    update();
  }

  // Future<void> googleSignIn() async {
  //   isLoggedIn(false);
  //   try {
  //     await pb.collection('users').authWithOAuth2('google', (url) async {
  //       await launchUrl(url);
  //       logger.i(url);
  //     });
  //   } catch (e) {
  //     status(Status.error);
  //     logger.e(e);
  //     // await bugnag.bugsnag.notify(e, stack);
  //   } finally {
  //     isLoggedIn(true);
  //     status(Status.success);
  //     Get.offAll(() => const NavBarPage());
  //   }
  // }

  Future<void> googleSignIn() async {
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
        authService.saveAuthState(authData.token, authData.record);
        Get.offAll(() => const NavBarPage());
      }
    } catch (e) {
      status(Status.error);
      err.value = e.toString();
      logger.e('Google Sign In Error: ${err.value}');
    }
    update();
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
      Get.offAll(() => HomePage());
    }
  }

  void loadCredentials() {
    final savedEmail = storage.read('rememberedEmail');
    final savedPassword = storage.read('rememberedPassword');

    if (savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      rememberMe.value = true;
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

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    initControllers();
    loadCredentials();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    // bannerAd?.dispose();
    // AdService.interstitialAd?.dispose();
    super.onClose();
  }
}
