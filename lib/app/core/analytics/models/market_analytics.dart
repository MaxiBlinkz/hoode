import 'package:fl_chart/fl_chart.dart';

class MarketAnalytics {
  static List<FlSpot> getPriceTrends() {
    return [
      FlSpot(0, 3),
      FlSpot(2, 2),
      FlSpot(4, 5),
      FlSpot(6, 3.1),
      FlSpot(8, 4),
      FlSpot(10, 3),
    ];
  }

  static List<FlSpot> getDemandTrends() {
    return [
      FlSpot(0, 4),
      FlSpot(2, 3),
      FlSpot(4, 4),
      FlSpot(6, 5),
      FlSpot(8, 3),
      FlSpot(10, 4),
    ];
  }

  static Map<String, double> getPropertyTypeDistribution() {
    return {
      'Apartments': 45,
      'Houses': 30,
      'Villas': 15,
      'Land': 10,
    };
  }

  static List<FlSpot> getRevenueData() {
    return [
      FlSpot(1, 4000),
      FlSpot(2, 3000),
      FlSpot(3, 5000),
      FlSpot(4, 6000),
      FlSpot(5, 4000),
      FlSpot(6, 7000),
    ];
  }
}
