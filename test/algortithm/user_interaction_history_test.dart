import 'package:flutter_test/flutter_test.dart';
import 'package:hoode/app/core/algorithms/models/user_interaction_history.dart';

void main() {
  group('UserInteractionHistory Tests', () {
    late UserInteractionHistory history;

    setUp(() {
      history = UserInteractionHistory(
        viewCounts: {'property1': 5},
        favorites: {'property2'},
        clicks: {
          'property3': [
            DateTime.now(),
            DateTime.now().subtract(const Duration(days: 2))
          ]
        },
      );
    });

    test('should return correct view count', () {
      expect(history.getViewCount('property1'), 5);
      expect(history.getViewCount('nonexistent'), 0);
    });

    test('should check favorites correctly', () {
      expect(history.isFavorite('property2'), true);
      expect(history.isFavorite('nonexistent'), false);
    });

    test('should count recent clicks within 7 days', () {
      expect(history.getRecentClicks('property3'), 2);
      expect(history.getRecentClicks('nonexistent'), 0);
    });
  });
}
