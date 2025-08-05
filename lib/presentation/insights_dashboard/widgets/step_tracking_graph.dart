import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StepTrackingGraph extends StatefulWidget {
  final List<Map<String, dynamic>> currentWeekData;
  final List<Map<String, dynamic>> previousWeekData;

  const StepTrackingGraph({
    super.key,
    required this.currentWeekData,
    required this.previousWeekData,
  });

  @override
  State<StepTrackingGraph> createState() => _StepTrackingGraphState();
}

class _StepTrackingGraphState extends State<StepTrackingGraph> {
  bool _showPreviousWeek = true;

  @override
  Widget build(BuildContext context) {
    // Calculate max step count for scaling
    int maxCurrentSteps = widget.currentWeekData
        .fold(0, (max, data) => data['count'] > max ? data['count'] : max);
    int maxPreviousSteps = widget.previousWeekData
        .fold(0, (max, data) => data['count'] > max ? data['count'] : max);
    int maxY = _showPreviousWeek
        ? (maxCurrentSteps > maxPreviousSteps
            ? maxCurrentSteps
            : maxPreviousSteps)
        : maxCurrentSteps;
    // Round up to the nearest thousand + 2000 for better visualization
    maxY = ((maxY ~/ 1000) + 3) * 1000;

    return Container(
      height: 30.h,
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Empty space for alignment
              SizedBox(width: 8.w),

              // Legend
              Row(
                children: [
                  Container(
                    width: 3.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'This Week',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withAlpha(179),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Visibility(
                    visible: _showPreviousWeek,
                    child: Row(
                      children: [
                        Container(
                          width: 3.w,
                          height: 0.5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withAlpha(179),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Last Week',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Toggle switch
              Switch(
                value: _showPreviousWeek,
                onChanged: (value) {
                  setState(() {
                    _showPreviousWeek = value;
                  });
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: AppTheme.lightTheme.colorScheme.surface,
                    tooltipPadding: EdgeInsets.all(2.w),
                    tooltipMargin: 2.h,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        final data = spot.barIndex == 0
                            ? widget.currentWeekData[spot.x.toInt()]
                            : widget.previousWeekData[spot.x.toInt()];
                        final label =
                            spot.barIndex == 0 ? 'This Week' : 'Last Week';
                        return LineTooltipItem(
                          '${data['count']} steps\n',
                          TextStyle(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: '$label - ${data['day']}',
                              style: TextStyle(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withAlpha(179),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 &&
                            index < widget.currentWeekData.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: Text(
                              widget.currentWeekData[index]['day'],
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
                        // Show Y-axis labels at nice intervals
                        if (value % 2000 == 0) {
                          return Text(
                            '${value ~/ 1000}k',
                            style: TextStyle(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withAlpha(179),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          );
                        }
                        return Container();
                      },
                      reservedSize: 8.w,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 2000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withAlpha(26),
                      strokeWidth: 1,
                    );
                  },
                ),
                maxY: maxY.toDouble(),
                lineBarsData: [
                  // Current week line
                  LineChartBarData(
                    spots: widget.currentWeekData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          entry.value['count'].toDouble());
                    }).toList(),
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    barWidth: 0.8.w,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 1.w,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          strokeWidth: 0.5.w,
                          strokeColor:
                              AppTheme.lightTheme.colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color:
                          AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                    ),
                  ),
                  // Previous week line (shown conditionally)
                  if (_showPreviousWeek)
                    LineChartBarData(
                      spots:
                          widget.previousWeekData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(),
                            entry.value['count'].toDouble());
                      }).toList(),
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withAlpha(179),
                      barWidth: 0.8.w,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 1.w,
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withAlpha(179),
                            strokeWidth: 0.5.w,
                            strokeColor:
                                AppTheme.lightTheme.colorScheme.surface,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
