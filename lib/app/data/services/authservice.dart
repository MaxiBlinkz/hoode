import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './supabase_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';
import 'package:logger/logger.dart';

class AuthService extends GetxService {
  final storage = GetStorage();
  final isAuthenticated = false.obs;
  final user = Rxn<User>();
  final userProfile = Rxn<Map<String, dynamic>>();
  final logger = Logger();
  
  // Get Supabase client from SupabaseService
  SupabaseClient get _client => SupabaseService.to.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void onInit() {
    super.onInit();
    
    // Set initial auth state
    user.value = _client.auth.currentUser;
    isAuthenticated.value = user.value != null;
    
    // Listen for auth state changes
    _client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      user.value = session?.user;
      isAuthenticated.value = session != null;
      
      if (event == AuthChangeEvent.signedIn) {
        // Load user profile after sign in
        _loadUserProfile();
      } else if (event == AuthChangeEvent.signedOut) {
        userProfile.value = null;
      }
    });
    
    // Load user profile if already authenticated
    if (isAuthenticated.value) {
      _loadUserProfile();
    }
  }
  
  // AUTHENTICATION METHODS
  
  Future<User?> signInWithEmail(String email, String password, {bool rememberMe = false}) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      // Store remember me preference
      if (rememberMe) {
        storage.write('rememberedEmail', email);
        storage.write('rememberedPassword', password);
      } else {
        storage.remove('rememberedEmail');
        storage.remove('rememberedPassword');
      }
      
      Get.offAll(() => const NavBarPage());
      return response.user;
    } catch (e) {
      logger.e('Sign in error: $e');
      rethrow; // Let the UI handle the error
    }
  }
  
  Future<void> signUpWithEmail(String email, String password, String fullName) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        // Create user profile
        await _client.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
        });
        
        // Navigate to profile setup
        Get.offAllNamed('/profile-setup', arguments: {'id': response.user!.id});
      }
    } catch (e) {
      logger.e('Sign up error: $e');
      rethrow;
    }
  }
  
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (response.user != null) {
        // Check if user profile exists, if not create it
        final userExists = await _client
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();
            
        if (userExists == null) {
          // Create user profile
          await _client.from('users').insert({
            'id': response.user!.id,
            'email': response.user!.email,
            'full_name': googleUser.displayName,
            'avatar_url': googleUser.photoUrl,
          });
        }
        
        Get.offAll(() => const NavBarPage());
      }
    } catch (e) {
      logger.e('Google sign in error: $e');
      rethrow;
    }
  }
  
  Future<void> signInWithApple() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.supabase.hoode://login-callback/',
      );
      // The redirect will be handled by Supabase's deep link handler
    } catch (e) {
      logger.e('Apple sign in error: $e');
      rethrow;
    }
  }
  
  Future<void> signInWithFacebook() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'io.supabase.hoode://login-callback/',
      );
      // The redirect will be handled by Supabase's deep link handler
    } catch (e) {
      logger.e('Facebook sign in error: $e');
      rethrow;
    }
  }
  
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      storage.remove('rememberedEmail');
      storage.remove('rememberedPassword');
      
      // Only navigate if GetX is properly initialized
      if (Get.isRegistered<GetMaterialApp>()) {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      logger.e('Sign out error: $e');
      rethrow;
    }
  }
  
  // USER PROFILE METHODS
  
  Future<void> _loadUserProfile() async {
    if (user.value == null) return;
    
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', user.value!.id)
          .single();
      
      userProfile.value = response;
    } catch (e) {
      logger.e('Error loading user profile: $e');
    }
  }
  
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    if (user.value == null) return;
    
    try {
      await _client
          .from('users')
          .update(data)
          .eq('id', user.value!.id);
      
      // Refresh profile data
      await _loadUserProfile();
    } catch (e) {
      logger.e('Error updating user profile: $e');
      rethrow;
    }
  }
  
  // HELPER METHODS
  
  void requireAuth(Function callback) {
    if (isAuthenticated.value) {
      callback();
    } else {
      Get.toNamed('/login');
    }
  }
  
  Map<String, String>? getRememberedCredentials() {
    final email = storage.read<String>('rememberedEmail');
    final password = storage.read<String>('rememberedPassword');
    
    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }
}
