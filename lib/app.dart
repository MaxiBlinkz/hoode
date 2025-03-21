import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/bindings/application_bindings.dart';
import 'app/core/theme/theme_controller.dart';
import 'package:toastification/toastification.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/theme.dart';

import 'flavors.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    
    return ToastificationWrapper(
      child: Obx(() => GetMaterialApp(
        title: F.title,
        debugShowCheckedModeBanner: true,
        initialBinding: ApplicationBindings(),
            theme: lightTheme,
            darkTheme:
                darkTheme,
            themeMode: themeController.isDarkMode.value
                ? ThemeMode.dark
                : ThemeMode.light,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        builder: (context, child) {
          return _flavorBanner(
            child: child ?? Container(),
            show: kDebugMode,
          );
        },
          )),
    );
  }
}


  Widget _flavorBanner({
    required Widget child,
    bool show = true,
  }) =>
      show
          ? Banner(
              child: child,
              location: BannerLocation.topStart,
              message: F.name,
              color: Colors.green.withOpacity(0.6),
            textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  letterSpacing: 1.0),
              textDirection: TextDirection.ltr,
            )
          : child;

