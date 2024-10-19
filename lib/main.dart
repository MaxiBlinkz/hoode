import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:hoode/app/core/config/constants.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/core/bindings/application_bindings.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // LicenseRegistry.addLicense(() async* {
  //   final license = await rootBundle.loadString('assets/fonts/OFL.txt');
  //   yield LicenseEntryWithLineBreaks(['assets/fonts/'], license);
  // });

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Your App Title',
      initialBinding: ApplicationBindings(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
