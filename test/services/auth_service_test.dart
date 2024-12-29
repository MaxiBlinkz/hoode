import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hoode/app/data/services/authservice.dart';
import 'package:mockito/mockito.dart';
import 'package:pocketbase/pocketbase.dart';

class MockGetStorage extends Mock implements GetStorage {}
class MockPocketBase extends Mock implements PocketBase {}

void main() {
  late AuthService authService;
  late MockGetStorage mockStorage;
  late MockPocketBase mockPb;

  setUp(() {
    mockStorage = MockGetStorage();
    mockPb = MockPocketBase();
    Get.put(AuthService());
    authService = Get.find<AuthService>();
  });

  group('AuthService Tests', () {
    test('checkLoginStatus should authenticate user with valid stored credentials', () async {
      when(mockStorage.read('authToken')).thenReturn('valid_token');
      when(mockStorage.read('userData')).thenReturn({'id': 'user123'});
      
      await authService.checkLoginStatus();
      
      expect(authService.isAuthenticated.value, true);
    });

    test('logout should clear auth state', () {
      authService.logout();
      
      expect(authService.isAuthenticated.value, false);
      verify(mockStorage.remove('authToken')).called(1);
      verify(mockStorage.remove('userData')).called(1);
    });
  });
}
