import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/core/config/app_config.dart';
import 'app/core/theme/theme_controller.dart';
import 'app/data/services/authservice.dart';
import 'app/data/services/bookmarkservice.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ThemeController(), permanent: true);
  await AppConfig.initialize();

  await Supabase.initialize(
    url: 'https://bhamvtgrierglecqrpph.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoYW12dGdyaWVyZ2xlY3FycHBoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU5NjQ1MDUsImV4cCI6MjA2MTU0MDUwNX0.gAjqVQoxJk-iLilidaPwu31uiVhgx2847cBuHH5ew2M',
    //authCallbackUrlHostname: 'login-callback', // This matches the path in your redirectTo URL
  );
  
  // Listen for auth state changes
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;
    if (event == AuthChangeEvent.signedIn) {
      // User has signed in, navigate to home page
      Get.offAll(() => const NavBarPage());
    }
  });

  final authService = Get.put(AuthService());
  
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
