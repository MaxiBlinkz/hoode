import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/authservice.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    if (!authService.isLoggedIn) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
