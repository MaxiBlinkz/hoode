import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/authservice.dart';
import '../../data/services/adservice.dart';
import '../../data/services/bookmarkservice.dart';
import '../../data/services/user_service.dart';
import '../../data/services/supabase_service.dart';
import 'package:logger/logger.dart';

class SplashScreenController extends GetxController {
  // Services
  final authService = Get.find<AuthService>();
  final adService = Get.find<AdService>();
  final bookmarkService = Get.find<BookmarkService>();
  final userService = Get.find<UserService>();
  final storage = GetStorage();
  
  // State variables
  final isLoading = true.obs;
  final initializationProgress = 0.0.obs;
  final statusMessage = "Initializing...".obs;
  final hasError = false.obs;
  final errorMessage = "".obs;
  final appVersion = "0.1.0".obs;
  final isOfflineMode = false.obs;
  final updateAvailable = false.obs;

  // Add this to the class properties
  final List<RealtimeChannel> _activeChannels = [];

  // Logger
  final logger = Logger();

  // Minimum splash duration
  final minimumSplashDuration = const Duration(seconds: 2);

  // Get Supabase client
  SupabaseClient get _client => SupabaseService.to.client;

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  Future<void> initializeApp() async {
    final stopwatch = Stopwatch()..start();

    try {
      // Get app version
      statusMessage("Starting up...");
      initializationProgress(0.05);
      await _getAppVersion();

      // Check connectivity
      statusMessage("Checking connection...");
      initializationProgress(0.1);
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        isOfflineMode.value = true;
        statusMessage("Offline mode");
        await _loadCachedData();
      } else {
        // Check for app updates - Wrap this in its own try-catch
        statusMessage("Checking for updates...");
        initializationProgress(0.2);
        try {
        await _checkForUpdates();
        } catch (updateError) {
          logger.e('Error during update check: $updateError');
          // Continue with app initialization despite update check error
        }

        // Initialize ad services
        statusMessage("Initializing ads...");
        initializationProgress(0.3);
        await adService.createUniqueBannerAd();
        adService.loadInterstitialAd();

        // Check authentication status
        statusMessage("Checking authentication...");
        initializationProgress(0.5);

        // Load app data based on authentication status
        if (authService.isAuthenticated.value) {
          // Load user-specific data
          statusMessage("Loading your data...");
          initializationProgress(0.7);

          // Load data in parallel for better performance
          await Future.wait([
            bookmarkService.loadBookmarks(),
            userService.getCurrentUser(),
          ]);

          // Set up realtime subscriptions
          statusMessage("Setting up notifications...");
          initializationProgress(0.9);
          _setupRealtimeSubscriptions();
        }
      }

      // Check onboarding status
      await _checkOnboardingStatus();

      // Ensure minimum splash duration for branding purposes
      initializationProgress(1.0);
      statusMessage("Ready!");

      final elapsedTime = stopwatch.elapsed;
      if (elapsedTime < minimumSplashDuration) {
        await Future.delayed(minimumSplashDuration - elapsedTime);
      }

      // Navigate to appropriate screen
      navigateToNextScreen();
    } catch (e) {
      logger.e('Initialization error: $e');
      hasError.value = true;
      errorMessage.value = _getUserFriendlyErrorMessage(e.toString());
      statusMessage("Error occurred");

      // Show error for a moment before redirecting
      await Future.delayed(const Duration(seconds: 2));

      if (!isOfflineMode.value) {
        Get.offAllNamed('/login');
      } else {
        navigateToNextScreen();
      }
    } finally {
      isLoading.value = false;
      stopwatch.stop();
    }
  }

  void navigateToNextScreen() {
    if (updateAvailable.value && storage.read('force_update') == true) {
      Get.offAllNamed('/update-required');
    } else if (!storage.read('onboarding_completed')) {
      Get.offAllNamed('/onboarding');
    } else if (authService.isAuthenticated.value) {
      Get.offAllNamed('/nav-bar');
    } else {
      Get.offAllNamed('/login');
    }
  }

  String _getUserFriendlyErrorMessage(String error) {
    if (error.contains('connection') || error.contains('network')) {
      return 'Unable to connect to the server. Please check your internet connection.';
    } else if (error.contains('timeout')) {
      return 'Connection timed out. Please try again later.';
    } else if (error.contains('authentication')) {
      return 'Authentication error. Please log in again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = "${packageInfo.version} (${packageInfo.buildNumber})";
    } catch (e) {
      appVersion.value = "0.1.0";
    }
  }

  Future<void> _loadCachedData() async {
    try {
      // Load cached data from local storage
      initializationProgress(0.4);

      // Check if we have cached user data
      final cachedUserData = storage.read('userData');
      if (cachedUserData != null) {
        initializationProgress(0.6);
        statusMessage("Loading cached data...");
      }

      initializationProgress(0.8);
    } catch (e) {
      logger.e('Error loading cached data: $e');
    }
  }

  Future<void> _checkForUpdates() async {
    try {
      // First check if we can connect to Supabase
      if (_client == null) {
        logger.w('Supabase client is not initialized');
        return;
      }

      // Use a more robust query that won't fail if there are no records
      final response = await _client
          .from('app_config')
          .select('latest_version, force_update')
          .limit(1)
          .maybeSingle();

      // If no data was returned, just return without error
      if (response == null) {
        logger.w('No app_config data found');
        return;
      }

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
    
      // Check if the response contains the expected fields
      if (response['latest_version'] == null) {
        logger.w('latest_version field not found in app_config');
        return;
      }
    
      final latestVersion = response['latest_version'];

      if (currentVersion != latestVersion) {
        updateAvailable.value = true;
        // Check if force_update exists before writing it
        if (response['force_update'] != null) {
        storage.write('force_update', response['force_update']);
        } else {
          storage.write('force_update', false);
        }
      }
    } catch (e) {
      // Log more details about the error
      logger.w('Update check failed: $e');
      // Don't let this error affect the rest of the app initialization
    }
  }


  Future<void> _checkOnboardingStatus() async {
    final hasCompletedOnboarding =
        storage.read('onboarding_completed') ?? false;
    if (!hasCompletedOnboarding && !authService.isAuthenticated.value) {
      statusMessage("Preparing onboarding...");
    }
  }

  void _setupRealtimeSubscriptions() {
    // Set up realtime subscriptions for bookmarks, messages, etc.
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    // Create a channel for bookmarks
    final bookmarksChannel = _client.channel('public:bookmarks');

    // Subscribe to bookmark changes
    bookmarksChannel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'bookmarks',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      callback: (payload) {
        // Reload bookmarks when changes occur
        bookmarkService.loadBookmarks();
      },
    );

    // Subscribe to the channel
    bookmarksChannel.subscribe();

    // Create a channel for messages
    final messagesChannel = _client.channel('public:messages');

    // Subscribe to message changes
    messagesChannel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      callback: (payload) {
        // Handle new messages
        // This would typically update a badge count or show a notification
        logger.i('New message received: ${payload.toString()}');
      },
    );

    // Subscribe to the messages channel
    messagesChannel.subscribe();

    // Store channel references for cleanup
    _activeChannels.add(bookmarksChannel);
    _activeChannels.add(messagesChannel);

    logger.i('Realtime subscriptions set up for user: $userId');
  }

  void retryInitialization() {
    hasError.value = false;
    errorMessage.value = "";
    initializationProgress(0.0);
    statusMessage("Retrying...");
    initializeApp();
  }

  @override
  void onClose() {
    // Clean up realtime subscriptions
    for (final channel in _activeChannels) {
      channel.unsubscribe();
    }
    _activeChannels.clear();
    super.onClose();
  }
}
