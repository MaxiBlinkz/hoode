import 'dart:convert';
// import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:hoode/app/data/exceptions/exceptions.dart';
import 'package:hoode/app/data/services/db_helper.dart';
import 'package:http/http.dart' as http;
import '../models/property.dart';

class RecommenderService {
  String? baseUrl;
  final http.Client client;

  RecommenderService({required this.client}) {
    _initializeBaseUrl();
  }

  Future<void> _initializeBaseUrl() async {
    baseUrl = await DbHelper.getPocketbaseUrl();
  }

  Future<List<Property>> getRecommendations({
    required String userId,
    required String token,
  }) async {

    if (baseUrl == null) {
      await _initializeBaseUrl();
    }
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/recommendations/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return (data['recommendations'] as List)
            .map((propertyJson) => Property.fromJson(propertyJson))
            .toList();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  Future<Map<String, dynamic>> getMarketTrends({
    required String token,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/market-trends'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> updateUserPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
    required String token,
  }) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/user-preferences/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(preferences),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw ServerException();
    }
  }
}
