import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:toastification/toastification.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:app_links/app_links.dart';
import 'app/core/bindings/application_bindings.dart';
import 'app/routes/app_pages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();


  await bugsnag.start(apiKey: BUGSNAG_API_KEY);
  await bugsnag.setUser(id: '1', email: 'test@email.com', name: 'Test User');

  final _appLinks = AppLinks();
  
  // Setup deep link listener
  _appLinks.uriLinkStream.listen((Uri? uri) {
    if (uri != null && uri.host == 'listing') {
      final listingId = uri.pathSegments.last;
      Get.toNamed('/listing-detail', arguments: listingId);
    }
  });

await SentryFlutter.init(
    (options) {
      options.dsn = 'https://6685056ca34cce279f6104225aeb1145@o4508202731634688.ingest.us.sentry.io/4508202734321664';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );await SentryFlutter.init(
    (options) {
      options.dsn = 'https://6685056ca34cce279f6104225aeb1145@o4508202731634688.ingest.us.sentry.io/4508202734321664';
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
        title: 'Your App Title',
        initialBinding: ApplicationBindings(),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
  //);,
  );


  
}
