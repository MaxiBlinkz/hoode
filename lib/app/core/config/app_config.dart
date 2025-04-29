
import 'package:hoode/app/data/services/db_helper.dart';

class AppConfig {
  static const bool useLocalPocketbase = bool.fromEnvironment('useLocalPocketbase');
  static late final String pocketbaseUrl;

  static Future<void> initialize() async {
    pocketbaseUrl = useLocalPocketbase 
      ? await DbHelper.getPocketbaseUrl()
      : String.fromEnvironment('pocketbaseUrl');
  }
}
