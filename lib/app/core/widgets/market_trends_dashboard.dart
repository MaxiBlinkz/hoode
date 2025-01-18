import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MarketTrendsDashboard extends StatelessWidget {
  final List<FlSpot> priceTrend;
  final List<FlSpot> demandTrend;
  final Map<String, double> propertyTypes;
  final List<FlSpot> revenue;

  const MarketTrendsDashboard({
    Key? key,
    required this.priceTrend,
    required this.demandTrend,
    required this.propertyTypes,
    required this.revenue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTrendChart(),
        const SizedBox(height: 24),
        _buildPropertyTypesPieChart(),
        const SizedBox(height: 24),
        _buildRevenueChart(),
      ],
    );
  }

  Widget _buildTrendChart() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Market Trends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: priceTrend,
                      color: Colors.blue,
                      barWidth: 3,
                    ),
                    LineChartBarData(
                      spots: demandTrend,
                      color: Colors.red,
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTypesPieChart() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Property Types Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: propertyTypes.entries.map((entry) {
                    return PieChartSectionData(
                      value: entry.value,
                      title: '${entry.key}\n${entry.value}%',
                      radius: 100,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Revenue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  barGroups: revenue.map((spot) {
                    return BarChartGroupData(
                      x: spot.x.toInt(),
                      barRods: [
                        BarChartRodData(
                          toY: spot.y,
                          color: Colors.green,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
