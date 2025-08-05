import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/ai_insight_card.dart';
import './widgets/date_selector.dart';
import './widgets/health_metric_card.dart';
import './widgets/medication_adherence_chart.dart';
import './widgets/step_tracking_graph.dart';

class InsightsDashboard extends StatefulWidget {
  const InsightsDashboard({super.key});

  @override
  State<InsightsDashboard> createState() => _InsightsDashboardState();
}

class _InsightsDashboardState extends State<InsightsDashboard> {
  // Mock data
  final Map<String, dynamic> weeklyStats = {
    'dateRange': 'June 10 - June 16, 2023',
    'medicationAdherence': [
      {'day': 'Mon', 'adherence': 1.0}, // 100%
      {'day': 'Tue', 'adherence': 0.75}, // 75%
      {'day': 'Wed', 'adherence': 1.0}, // 100%
      {'day': 'Thu', 'adherence': 0.5}, // 50%
      {'day': 'Fri', 'adherence': 0.8}, // 80%
      {'day': 'Sat', 'adherence': 1.0}, // 100%
      {'day': 'Sun', 'adherence': 0.25}, // 25%
    ],
    'stepCounts': [
      {'day': 'Mon', 'count': 8500},
      {'day': 'Tue', 'count': 7200},
      {'day': 'Wed', 'count': 9800},
      {'day': 'Thu', 'count': 5400},
      {'day': 'Fri', 'count': 8100},
      {'day': 'Sat', 'count': 11200},
      {'day': 'Sun', 'count': 6300},
    ],
    'previousWeekSteps': [
      {'day': 'Mon', 'count': 7800},
      {'day': 'Tue', 'count': 8100},
      {'day': 'Wed', 'count': 7600},
      {'day': 'Thu', 'count': 6900},
      {'day': 'Fri', 'count': 7500},
      {'day': 'Sat', 'count': 9800},
      {'day': 'Sun', 'count': 7200},
    ],
    'metrics': {
      'averageSteps': 8071,
      'stepTrend': 'up', // 'up', 'down', or 'stable'
      'medicationCompliance': 0.76, // 76%
      'medicationStreak': 12, // 12 days
      'sleepQuality': 82, // 82%
      'heartRateVariability': 52, // 52ms
    },
    'aiInsights': [
      'You tend to miss evening medications more than morning ones',
      'Your step count increases when you take your medication regularly',
      'Your sleep quality improves when you complete 8,000+ steps',
    ],
  };

  // Selected time period
  String _selectedPeriod = 'week'; // 'week', 'month', 'year'

  void _changePeriod(String period) {
    setState(() {
      _selectedPeriod = period;
      // In a real app, we would load different data based on the period
    });
  }

  void _navigateToPreviousPeriod() {
    // In a real app, this would load data for the previous period
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loading previous $_selectedPeriod data'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _navigateToNextPeriod() {
    // In a real app, this would load data for the next period
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loading next $_selectedPeriod data'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulating data refresh
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 3.h),
                DateSelector(
                  dateRange: weeklyStats['dateRange'],
                  onPrevious: _navigateToPreviousPeriod,
                  onNext: _navigateToNextPeriod,
                  period: _selectedPeriod,
                  onPeriodChanged: _changePeriod,
                ),
                SizedBox(height: 3.h),
                Text(
                  'Medication Adherence',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                MedicationAdherenceChart(
                  adherenceData: weeklyStats['medicationAdherence'],
                ),
                SizedBox(height: 3.h),
                Text(
                  'Step Tracking',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                StepTrackingGraph(
                  currentWeekData: weeklyStats['stepCounts'],
                  previousWeekData: weeklyStats['previousWeekSteps'],
                ),
                SizedBox(height: 3.h),
                Text(
                  'Health Metrics',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildHealthMetricsGrid(),
                SizedBox(height: 3.h),
                Text(
                  'AI-Powered Insights',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                ..._buildAIInsights(),
                SizedBox(height: 5.h), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Health Insights',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () {
            // Show options menu
            _showOptionsMenu();
          },
        ),
      ],
    );
  }

  Widget _buildHealthMetricsGrid() {
    final metrics = weeklyStats['metrics'];
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 2.h,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        HealthMetricCard(
          title: 'Average Steps',
          value: '${metrics['averageSteps']}',
          trend: metrics['stepTrend'],
          iconName: 'directions_walk',
        ),
        HealthMetricCard(
          title: 'Medication Compliance',
          value: '${(metrics['medicationCompliance'] * 100).toInt()}%',
          subtitle: '${metrics['medicationStreak']} day streak',
          iconName: 'medication',
        ),
        HealthMetricCard(
          title: 'Sleep Quality',
          value: '${metrics['sleepQuality']}%',
          iconName: 'bedtime',
        ),
        HealthMetricCard(
          title: 'Heart Rate Variability',
          value: '${metrics['heartRateVariability']} ms',
          iconName: 'favorite',
        ),
      ],
    );
  }

  List<Widget> _buildAIInsights() {
    final insights = weeklyStats['aiInsights'];
    return insights.map<Widget>((insight) {
      return AiInsightCard(insight: insight);
    }).toList();
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(
                    77,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Options',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'download',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                title: Text('Export Data'),
                onTap: () {
                  Navigator.pop(context);
                  // Show export options
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Export options would appear here'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'filter_list',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                title: Text('Filter Data'),
                onTap: () {
                  Navigator.pop(context);
                  // Show filter options
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Filter options would appear here'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'settings',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                title: Text('Insight Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings
                  Navigator.pushNamed(context, '/settings-screen');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
