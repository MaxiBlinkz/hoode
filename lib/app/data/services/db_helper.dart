import 'dart:io';

import 'package:flutter/foundation.dart';

class DbHelper {
  static const String POCKETBASE_URL_ANDROID = "http://10.0.2.2:8090";
  static const String POCKETBASE_URL = "https://hoode.pockethost.io";

  static String getPocketbaseUrl(){
    if(kIsWeb || (Platform.isAndroid && (Platform.environment.containsKey('ANDROID_EMULATOR')))){
      return POCKETBASE_URL_ANDROID;
    } else{
      return POCKETBASE_URL;
    }
  }

}