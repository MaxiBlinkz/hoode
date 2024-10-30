import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:toastification/toastification.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:app_links/app_links.dart';
import 'app/core/bindings/application_bindings.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isWindows = Platform.isWindows;
  if (!isWindows) {
    await bugsnag.start(apiKey: BUGSNAG_API_KEY);
    await bugsnag.setUser(id: '1', email: 'test@email.com', name: 'Test User');
  }
  

  // final _appLinks = AppLinks();

  // // Setup deep link listener
  // _appLinks.uriLinkStream.listen((Uri? uri) {
  //   if (uri != null && uri.host.contains('hoode-2024.web.app')) {
  //     // final listingId = uri.pathSegments.last;
  //     // Get.toNamed('/listing-detail', arguments: listingId);
  //     Get.toNamed('/home');
  //   }
  // });

  runApp(
    ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Your App Title',
        initialBinding: ApplicationBindings(),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
  //);
}
