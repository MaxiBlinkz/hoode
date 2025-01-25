import 'package:get/get.dart';
import '../../data/services/authservice.dart';
import '../../data/services/adservice.dart';
import '../../data/services/bookmarkservice.dart';
import '../../data/services/user_service.dart';

class SplashScreenController extends GetxController {
  final authService = Get.find<AuthService>();
  final adService = Get.find<AdService>();
  final bookmarkService = Get.find<BookmarkService>();
  final userService = Get.find<UserService>();
  
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 3)); // Minimum splash duration
    
    try {
      // Initialize core services
      await authService.checkLoginStatus();
      await adService.createUniqueBannerAd();
      adService.loadInterstitialAd();

      if (authService.isAuthenticated.value) {
        // Load user-specific data
        await bookmarkService.loadBookmarks();
        await userService.getCurrentUser();
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize app');
      Get.offAllNamed('/login');
    }
  }
}
