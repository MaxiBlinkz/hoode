import 'package:dio/dio.dart';
import 'package:hoode/app/data/models/property.dart';
//import 'package:http/http.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

class Apis {
  static const String url = "http://10.0.2.2:3001";
  static const String properties = "/api/properties";
}

@RestApi(baseUrl: Apis.url)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(Apis.properties)
  Future<List<Property>> getProperties();

}

