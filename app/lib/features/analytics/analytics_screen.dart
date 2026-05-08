import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/glass_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
        children: [
          _ChartCard(title: 'Daily calories', color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 14),
          _ChartCard(title: 'Weekly protein', color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 14),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Macro split', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(sectionsSpace: 4, centerSpaceRadius: 44, sections: [
                      PieChartSectionData(value: 40, title: 'Carbs', color: Colors.blueAccent),
                      PieChartSectionData(value: 35, title: 'Protein', color: Colors.greenAccent),
                      PieChartSectionData(value: 25, title: 'Fat', color: Colors.orangeAccent),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          SizedBox(
            height: 190,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    barWidth: 4,
                    color: color,
                    dotData: const FlDotData(show: false),
                    spots: const [
                      FlSpot(0, 1600),
                      FlSpot(1, 2100),
                      FlSpot(2, 1880),
                      FlSpot(3, 2250),
                      FlSpot(4, 1980),
                      FlSpot(5, 1760),
                      FlSpot(6, 2050),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
