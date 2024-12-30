import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/bindings/application_bindings.dart';
import 'package:hoode/app/core/theme/dark_theme.dart';
import 'package:hoode/app/core/theme/light_theme.dart';
import 'package:hoode/app/core/theme/theme_controller.dart';
import 'package:toastification/toastification.dart';
import 'package:hoode/app/routes/app_pages.dart';

import 'flavors.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: F.title,
        debugShowCheckedModeBanner: true,
        initialBinding: ApplicationBindings(),
        theme: FlexThemeData.light(scheme: FlexScheme.greenM3),
        darkTheme: FlexThemeData.dark(scheme: FlexScheme.greenM3),
        themeMode: ThemeMode.system,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        builder: (context, child) {
          return _flavorBanner(
            child: child ?? Container(),
            show: kDebugMode,
          );
        },
      ),
    );
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
              textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  letterSpacing: 1.0),
              textDirection: TextDirection.ltr,
            )
          : child;
}
