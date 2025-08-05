import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/circular_progress_widget.dart';
import './widgets/daily_goal_widget.dart';
import './widgets/statistics_card_widget.dart';
import './widgets/weekly_chart_widget.dart';

class StepsTracker extends StatefulWidget {
  const StepsTracker({super.key});

  @override
  State<StepsTracker> createState() => _StepsTrackerState();
}

class _StepsTrackerState extends State<StepsTracker>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  String _status = '?';

  // Mock data for steps tracking
  int currentSteps = 0;
  int dailyGoal = 10000;
  double calories = 0;
  String activeTime = "0h 0m";
  double distance = 0;
  DateTime lastSyncTime = DateTime.now().subtract(const Duration(minutes: 5));

  final List<Map<String, dynamic>> weeklyData = [
    {"day": "Mon", "steps": 8500},
    {"day": "Tue", "steps": 9200},
    {"day": "Wed", "steps": 7800},
    {"day": "Thu", "steps": 10500},
    {"day": "Fri", "steps": 9800},
    {"day": "Sat", "steps": 11200},
    {"day": "Sun", "steps": 7842},
  ];

  int _selectedGoal = 10000;

  bool get isPedometerSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  void initState() {
    super.initState();
    _selectedGoal = dailyGoal;
    if (isPedometerSupported) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          ?.listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);

      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream?.listen(onStepCount).onError(onStepCountError);
    }
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation =
        Tween<double>(
          begin: 0.0,
          end: (dailyGoal > 0 ? currentSteps / dailyGoal : 0.0),
        ).animate(
          CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
        );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void onStepCount(StepCount event) {
    if (kDebugMode) {
      print(event);
    }
    setState(() {
      currentSteps = event.steps;
      calories = currentSteps * 0.04;
      distance = currentSteps * 0.0008;
    });
    _updateProgressAnimation();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    if (kDebugMode) {
      print(event);
    }
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    if (kDebugMode) {
      print('onPedestrianStatusError: $error');
    }
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    if (kDebugMode) {
      print(_status);
    }
  }

  void onStepCountError(error) {
    if (kDebugMode) {
      print('onStepCountError: $error');
    }
    setState(() {});
  }

  void _updateProgressAnimation() {
    _progressAnimation =
        Tween<double>(
          begin: 0.0,
          end: (dailyGoal > 0 ? currentSteps / dailyGoal : 0.0),
        ).animate(
          CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
        );
    _progressController.reset();
    _progressController.forward();
  }

  void _showGoalPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Set Daily Goal',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child: ListWheelScrollView.useDelegate(
                            controller: FixedExtentScrollController(
                              initialItem: (_selectedGoal ~/ 1000) - 1,
                            ),
                            itemExtent: 50,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedGoal = (index + 1) * 1000;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                final goal = (index + 1) * 1000;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedGoal = goal;
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      '$goal steps',
                                      style: goal == _selectedGoal
                                          ? AppTheme
                                                .lightTheme
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color: AppTheme
                                                      .lightTheme
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                )
                                          : AppTheme
                                                .lightTheme
                                                .textTheme
                                                .bodyLarge,
                                    ),
                                  ),
                                );
                              },
                              childCount: 100,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  this.setState(() {
                                    dailyGoal = _selectedGoal;
                                  });
                                  _updateProgressAnimation();
                                  Navigator.pop(context);
                                },
                                child: const Text('Save'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      lastSyncTime = DateTime.now();
      _updateProgressAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Steps Tracker',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular Progress Section
              CircularProgressWidget(
                currentSteps: currentSteps,
                dailyGoal: dailyGoal,
                progressAnimation: _progressAnimation,
              ),

              const SizedBox(height: 32),

              // Daily Goal Section
              DailyGoalWidget(
                currentSteps: currentSteps,
                dailyGoal: dailyGoal,
                onSetNewGoal: _showGoalPicker,
              ),

              const SizedBox(height: 32),

              // Statistics Cards
              Text(
                'Today\'s Statistics',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    StatisticsCardWidget(
                      icon: 'local_fire_department',
                      title: 'Calories',
                      value: calories.toStringAsFixed(1),
                      unit: 'kcal',
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    StatisticsCardWidget(
                      icon: 'schedule',
                      title: 'Active Time',
                      value: activeTime,
                      unit: '',
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    StatisticsCardWidget(
                      icon: 'straighten',
                      title: 'Distance',
                      value: distance.toStringAsFixed(1),
                      unit: 'km',
                      color: Colors.green,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Weekly Progress Chart
              Text(
                'Weekly Progress',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              WeeklyChartWidget(weeklyData: weeklyData),

              const SizedBox(height: 24),

              // Last Sync Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'sync',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last synced',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          Text(
                            '${lastSyncTime.hour.toString().padLeft(2, '0')}:${lastSyncTime.minute.toString().padLeft(2, '0')}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
