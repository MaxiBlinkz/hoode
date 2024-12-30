// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/theme/dark_theme.dart';
import 'package:hoode/app/core/theme/light_theme.dart';
import 'package:hoode/app/core/theme/theme_controller.dart';
import 'package:hoode/app/data/services/authservice.dart';
import 'package:pocketbase_server_flutter/pocketbase_server_flutter.dart';
import 'app/core/bindings/application_bindings.dart';
import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ThemeController(), permanent: true);
  PocketbaseServerFlutter.start(
    hostName: await PocketbaseServerFlutter.localIpAddress,
    port: "8080",
    dataPath: null,
    enablePocketbaseApiLogs: true,
  );
  final authService = Get.put(AuthService());
  await authService.checkLoginStatus();
  await MobileAds.instance.initialize();
 
  () => runApp(
        GetMaterialApp(
                debugShowCheckedModeBanner: true,
                title: 'Hoode',
                initialBinding: ApplicationBindings(),
                theme: LightTheme.theme,
                darkTheme: DarkTheme.theme,
                themeMode: ThemeController.to.themeMode.value,
                initialRoute: AppPages.INITIAL,
                getPages: AppPages.routes,
              ),
      );
      //);,
      
}
