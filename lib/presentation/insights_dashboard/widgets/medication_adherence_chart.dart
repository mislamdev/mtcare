import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MedicationAdherenceChart extends StatefulWidget {
  final List<Map<String, dynamic>> adherenceData;

  const MedicationAdherenceChart({
    super.key,
    required this.adherenceData,
  });

  @override
  State<MedicationAdherenceChart> createState() =>
      _MedicationAdherenceChartState();
}

class _MedicationAdherenceChartState extends State<MedicationAdherenceChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: AppTheme.lightTheme.colorScheme.surface,
              tooltipPadding: EdgeInsets.all(2.w),
              tooltipMargin: 2.h,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final adherence =
                    widget.adherenceData[groupIndex]['adherence'] as double;
                return BarTooltipItem(
                  '${(adherence * 100).toInt()}% Adherence\n',
                  TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: widget.adherenceData[groupIndex]['day'],
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withAlpha(179),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
              });
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < widget.adherenceData.length) {
                    return Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: Text(
                        widget.adherenceData[index]['day'],
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withAlpha(179),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                  return Container();
                },
                reservedSize: 3.h,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  String text = '';
                  if (value == 0) {
                    text = '0%';
                  } else if (value == 0.5) {
                    text = '50%';
                  } else if (value == 1) {
                    text = '100%';
                  }
                  return Text(
                    text,
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withAlpha(179),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 8.w,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: _buildBarGroups(),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 0.25,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(26),
                strokeWidth: 1,
              );
            },
          ),
          maxY: 1.05,
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.adherenceData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final adherence = data['adherence'] as double;

      Color barColor;
      if (adherence >= 0.8) {
        barColor = AppTheme.lightTheme.colorScheme.tertiary; // Success green
      } else if (adherence >= 0.5) {
        barColor =
            Colors.orange; // Warning yellow/orange
      } else {
        barColor = AppTheme.lightTheme.colorScheme.error; // Error red
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: adherence,
            color: barColor,
            width: 4.w,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(4),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 1,
              color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(26),
            ),
          ),
        ],
        showingTooltipIndicators: touchedIndex == index ? [0] : [],
      );
    }).toList();
  }
}