import 'package:flutter_test/flutter_test.dart';
import 'package:hoode/app/core/algorithms/models/seasonal_data.dart';
import 'package:clock/clock.dart';

void main() {
  group('SeasonalData Tests', () {
    late SeasonalData seasonalData;

    setUp(() {
      seasonalData = SeasonalData();
    });

    test('should return summer for June-August', () {
      final summer = DateTime(2024, 7, 1);
      withClock(Clock.fixed(summer), () {
        expect(seasonalData.getCurrentSeason(), Season.summer);
      });
    });

    test('should return winter for December-February', () {
      final winter = DateTime(2024, 12, 1);
      withClock(Clock.fixed(winter), () {
        expect(seasonalData.getCurrentSeason(), Season.winter);
      });
    });
  });
}
