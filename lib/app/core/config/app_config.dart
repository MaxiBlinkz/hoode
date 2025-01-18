
import 'package:pocketbase_server_flutter/pocketbase_server_flutter.dart';

class AppConfig {
  static const bool useLocalPocketbase = bool.fromEnvironment('useLocalPocketbase');
  static late final String pocketbaseUrl;

  static Future<void> initialize() async {
    pocketbaseUrl = useLocalPocketbase 
      ? PocketbaseServerFlutter.localIpAddress as String
      : String.fromEnvironment('pocketbaseUrl');
  }
}
