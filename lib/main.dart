import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/core/config/app_config.dart';
import 'app/core/theme/theme_controller.dart';
import 'app/data/services/authservice.dart';
import 'app/data/services/bookmarkservice.dart';
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
  // Initialize services
  Get.put(AuthService());
  Get.put(BookmarkService());
  await MobileAds.instance.initialize();

  runApp(const App());
}
