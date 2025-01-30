import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pocketbase/pocketbase.dart';

class ApiService {
  final Dio _dio = Dio();
  final storage = GetStorage();
  late final PocketBase pb;

  ApiService() {
    _dio.options.baseUrl = 'http://your-fastapi-url:8000';
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    
     _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final pbToken = pb.authStore.token;
        if (pbToken != null) {
          options.headers['X-PB-Token'] = pbToken;
        }
        return handler.next(options);
      },
    ));
  }

  Future<List<dynamic>> getRecommendations({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final properties = await pb.collection('properties').getFullList();
      
      final response = await _dio.post('/recommendations', 
        data: {
          'user_id': userId,
          'latitude': latitude,
          'longitude': longitude,
          'properties': properties,
          'pb_token': pb.authStore.token
        }
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to get recommendations: $e');
    }
  }

  Future<List<dynamic>> getSimilarProperties(String propertyId) async {
    try {
      final response = await _dio.get('/similar-properties/$propertyId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get similar properties: $e');
    }
  }

  Future<void> trackPropertyView(String userId, String propertyId) async {
    try {
      await _dio.post('/track-view', data: {
        'user_id': userId,
        'property_id': propertyId,
      });
    } catch (e) {
      throw Exception('Failed to track property view: $e');
    }
  }
}
