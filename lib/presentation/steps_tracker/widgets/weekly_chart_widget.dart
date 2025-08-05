import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WeeklyChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;

  const WeeklyChartWidget({
    super.key,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('This Week',
                style: AppTheme.lightTheme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: AppTheme.successLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                    'Average: ${_calculateAverage().toStringAsFixed(0)}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successLight,
                        fontWeight: FontWeight.w500))),
          ]),
          const SizedBox(height: 20),
          Expanded(
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxSteps() * 1.2,
                  barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                                '${rod.toY.round()} steps',
                                AppTheme.lightTheme.textTheme.bodySmall!
                                    .copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.surface,
                                        fontWeight: FontWeight.w500));
                          })),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < weeklyData.length) {
                                  return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                          (weeklyData[value.toInt()]["day"]
                                              as String),
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                                  color: AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .onSurfaceVariant)));
                                }
                                return const SizedBox.shrink();
                              },
                              reservedSize: 30)),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: _getMaxSteps() / 4,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                    '${(value / 1000).toStringAsFixed(0)}k',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant));
                              },
                              reservedSize: 40))),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _getMaxSteps() / 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      }),
                  barGroups: weeklyData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final steps = (data["steps"] as int).toDouble();
                    final isToday = index == weeklyData.length - 1;

                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                          toY: steps,
                          color: isToday
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.6),
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4))),
                    ]);
                  }).toList()))),
        ]));
  }

  double _getMaxSteps() {
    return weeklyData
        .map((data) => (data["steps"] as int).toDouble())
        .reduce((a, b) => a > b ? a : b);
  }

  double _calculateAverage() {
    final total = weeklyData
        .map((data) => (data["steps"] as int).toDouble())
        .reduce((a, b) => a + b);
    return total / weeklyData.length;
  }
}
