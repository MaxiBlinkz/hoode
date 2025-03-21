import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app/core/config/app_config.dart';
import 'app/core/theme/theme_controller.dart';
import 'app/data/services/authservice.dart';
import 'app/data/services/bookmarkservice.dart';
import 'package:pocketbase_server_flutter/pocketbase_server_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ThemeController(), permanent: true);
  await AppConfig.initialize();

  PocketbaseServerFlutter.start(
    hostName: await PocketbaseServerFlutter.localIpAddress,
    port: "8080",
    dataPath: null,
    enablePocketbaseApiLogs: true,
  );

  final authService = Get.put(AuthService());
  try {
    await authService.checkLoginStatus();
  } catch (e) {
    Get.snackbar(
      'Offline Mode',
      'You are currently offline. Some features may be limited.',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }
  Get.put(BookmarkService());
  await MobileAds.instance.initialize();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://6685056ca34cce279f6104225aeb1145@o4508202731634688.ingest.us.sentry.io/4508202734321664';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(const App()),
  );
}
