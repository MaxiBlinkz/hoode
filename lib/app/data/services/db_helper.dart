import 'dart:io';

// import 'package:flutter/foundation.dart';
import 'package:pocketbase_server_flutter/pocketbase_server_flutter.dart';

class DbHelper {
  static const String POCKETBASE_URL_ANDROID = "http://10.0.2.2:8090";
  static const String POCKETBASE_URL = "https://hoode.pockethost.io";
  

  static Future<String> getPocketbaseUrl() async {
    if (Platform.isAndroid &&
        Platform.environment.containsKey('ANDROID_EMULATOR')) {
      return POCKETBASE_URL_ANDROID;
    } else if (Platform.isAndroid) {
      String? pb = await PocketbaseServerFlutter.localIpAddress;
      return pb ?? POCKETBASE_URL; // Fallback to default URL if pb is null
    } else {
      return POCKETBASE_URL;
    }
  }


}