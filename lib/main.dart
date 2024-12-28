// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/dark_theme.dart';
import 'package:hoode/app/core/theme/light_theme.dart';
import 'package:hoode/app/core/theme/theme_controller.dart';
import 'package:hoode/app/data/services/authservice.dart';
// import 'package:hoode/app/core/config/constants.dart';
import 'package:toastification/toastification.dart';
// import 'package:bugsnag_flutter/bugsnag_flutter.dart';
// import 'package:app_links/app_links.dart';
import 'app/core/bindings/application_bindings.dart';
import 'app/routes/app_pages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final authService = Get.put(AuthService());
  await authService.checkLoginStatus();

  // bool isWindows = Platform.isWindows;
  // if (!isWindows) {
  //   await bugsnag.start(apiKey: BUGSNAG_API_KEY);
  //   await bugsnag.setUser(id: '1', email: 'test@email.com', name: 'Test User');
  // }

  // final _appLinks = AppLinks();

  // // Setup deep link listener
  // _appLinks.uriLinkStream.listen((Uri? uri) {
  //   if (uri != null && uri.host.contains('hoode-2024.web.app')) {
  //     // final listingId = uri.pathSegments.last;
  //     // Get.toNamed('/listing-detail', arguments: listingId);
  //     Get.toNamed('/home');
  //   }
  // });
  // Initialize AdMob
  await MobileAds.instance.initialize();
  await SentryFlutter.init((options) {
    options.dsn =
        'https://6685056ca34cce279f6104225aeb1145@o4508202731634688.ingest.us.sentry.io/4508202734321664';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
    // The sampling rate for profiling is relative to tracesSampleRate
    // Setting to 1.0 will profile 100% of sampled transactions:
    options.profilesSampleRate = 1.0;
  },
      appRunner: () => runApp(
            ToastificationWrapper(
              child: GetMaterialApp(
                debugShowCheckedModeBanner: true,
                title: 'Hoode',
                initialBinding: ApplicationBindings(),
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: ThemeController.to.themeMode.value,
                
                initialRoute: AppPages.INITIAL,
                getPages: AppPages.routes,
              ),
            ),
          )
      //);,
      );
}
