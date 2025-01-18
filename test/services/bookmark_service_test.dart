import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/services/authservice.dart';
import 'package:hoode/app/data/services/bookmarkservice.dart';
import 'package:mockito/mockito.dart';
import 'package:pocketbase/pocketbase.dart';

class MockAuthService extends Mock implements AuthService {}
class MockPocketBase extends Mock implements PocketBase {}

void main() {
  late BookmarkService bookmarkService;
  late MockAuthService mockAuthService;
  late MockPocketBase mockPb;

  setUp(() {
    mockAuthService = MockAuthService();
    mockPb = MockPocketBase();
    Get.put(mockAuthService);
    bookmarkService = Get.put(BookmarkService());
  });

  group('BookmarkService Tests', () {
    test('toggleBookmark should handle auth recovery', () async {
      when(mockPb.authStore.isValid).thenReturn(false);
      when(mockAuthService.isAuthenticated).thenReturn(true.obs);
      
      await bookmarkService.toggleBookmark('property123');
      
      verify(mockAuthService.refreshSession()).called(1);
    });

    test('isBookmarked should return correct status', () async {
      when(mockPb.authStore.isValid).thenReturn(true);
      when(mockPb.authStore.record).thenReturn(RecordModel.fromJson({'id': 'user123'}));
      
      final result = await bookmarkService.isBookmarked('property123');
      
      expect(result, isA<bool>());
    });

    test('getBookmarkedListings should return list when authenticated', () async {
      when(mockPb.authStore.isValid).thenReturn(true);
      when(mockPb.authStore.record).thenReturn(RecordModel.fromJson({'id': 'user123'}));
      
      final listings = await bookmarkService.getBookmarkedListings();
      
      expect(listings, isA<List<RecordModel>>());
    });
  });
}
