import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../insights_dashboard/insights_dashboard.dart';
import '../settings_screen/settings_screen.dart';
import './widgets/feature_buttons_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/step_tracker_widget.dart';
import './widgets/todays_medications_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _medicationsData = [];
  late Stream<StepCount> _stepCountStream;
  int _steps = 0;

  // Mock data for medications
  final List<Map<String, dynamic>> todaysMedications = [];

  final List<Map<String, dynamic>> upcomingMedications = [];

  // Mock step data
  final Map<String, dynamic> stepData = {
    "currentSteps": 0,
    "goalSteps": 10000,
    "calories": 0,
    "distance": 0,
    "activeTime": 0,
  };

  @override
  void initState() {
    super.initState();
    _loadMedications();
    if (!kIsWeb) {
      initPlatformState();
    }
  }

  Future<void> _loadMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final medicationsString = prefs.getString('medications');
    if (medicationsString != null) {
      final newMedicationsData = (jsonDecode(medicationsString) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      final newTodaysMedications = <Map<String, dynamic>>[];
      final newUpcomingMedications = <Map<String, dynamic>>[];
      final now = DateTime.now();

      for (var med in newMedicationsData) {
        final times = med['times'] as List<dynamic>;
        for (var timeEntry in times) {
          final time = timeEntry['time'] as String;
          final timeParts = time.split(':');
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final scheduledTime = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          final medicationWithTime = Map<String, dynamic>.from(med);
          medicationWithTime['specificTime'] = time;
          medicationWithTime['isTaken'] = timeEntry['isTaken'] as bool;

          if (scheduledTime.isAfter(now)) {
            newUpcomingMedications.add(medicationWithTime);
          }
          if (med['day'] == 'today') {
            newTodaysMedications.add(medicationWithTime);
          }
        }
      }

      if (mounted) {
        setState(() {
          _medicationsData = newMedicationsData;
          todaysMedications.clear();
          todaysMedications.addAll(newTodaysMedications);
          upcomingMedications.clear();
          upcomingMedications.addAll(newUpcomingMedications);
        });
      }
    }
  }

  void onStepCount(StepCount event) {
    if (kDebugMode) {
      print(event);
    }
    setState(() {
      _steps = event.steps;
      stepData['currentSteps'] = _steps;
      stepData['calories'] = _steps * 0.04;
      stepData['distance'] = _steps * 0.0008;
    });
  }

  void onStepCountError(error) {
    if (kDebugMode) {
      print('onStepCountError: $error');
    }
    setState(() {
      _steps = 0;
    });
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleMedicationTaken(int medicationId, String specificTime) async {
    setState(() {
      final medicationIndex = _medicationsData.indexWhere(
        (med) => (med["id"] as int) == medicationId,
      );
      if (medicationIndex != -1) {
        final medication = _medicationsData[medicationIndex];
        final times = medication['times'] as List<dynamic>;
        final timeIndex = times.indexWhere(
          (timeEntry) => timeEntry['time'] == specificTime,
        );
        if (timeIndex != -1) {
          times[timeIndex]['isTaken'] = !times[timeIndex]['isTaken'];
        }
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('medications', jsonEncode(_medicationsData));
    _loadMedications(); // Reload medications to reflect changes in UI
  }

  Future<void> _refreshData() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));
    _loadMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        iconTheme: IconThemeData(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
            onPressed: () {
              _showUpcomingMedications();
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _currentIndex == 0
          ? _buildFloatingActionButton()
          : null,
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const InsightsDashboard();
      case 2:
        return const SettingsScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Header
              GreetingHeaderWidget(upcomingMedications: upcomingMedications),

              SizedBox(height: 3.h),

              // Step Tracker
              StepTrackerWidget(
                stepData: stepData,
                onTap: () {
                  Navigator.pushNamed(context, '/steps-tracker');
                },
              ),

              SizedBox(height: 4.h),

              // Feature Buttons
              FeatureButtonsWidget(
                onAddMedicationTap: () {
                  Navigator.pushNamed(
                    context,
                    '/add-medicine',
                  ).then((_) => _loadMedications());
                },
                onHealthArticlesTap: () {
                  Navigator.pushNamed(
                    context,
                    '/medication-management',
                  ).then((_) => _loadMedications());
                },
              ),

              SizedBox(height: 4.h),

              // Today's Medications
              TodaysMedicationsWidget(
                medications: todaysMedications,
                onMedicationToggle: (medicationId, specificTime) {
                  _toggleMedicationTaken(medicationId, specificTime);
                },
                onMedicationLongPress: (medicationId, specificTime) {
                  _showMedicationActions(medicationId, specificTime);
                },
              ),

              SizedBox(height: 10.h), // Extra space for FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(
        153,
      ),
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            size: 24,
            color: _currentIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurface.withAlpha(153),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'insights',
            size: 24,
            color: _currentIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurface.withAlpha(153),
          ),
          label: 'Insights',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'settings',
            size: 24,
            color: _currentIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurface.withAlpha(153),
          ),
          label: 'Settings',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/add-medicine',
        ).then((_) => _loadMedications());
      },
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      icon: CustomIconWidget(
        iconName: 'add',
        size: 24,
        color: AppTheme.lightTheme.colorScheme.onPrimary,
      ),
      label: Text(
        'Add Medicine',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showUpcomingMedications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(77),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Upcoming Medications',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            if (upcomingMedications.isEmpty)
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  'No upcoming medications.',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: upcomingMedications.length,
                  itemBuilder: (context, index) {
                    final medication = upcomingMedications[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 1.h),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medication['name'],
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Time: ${medication['times'].join(', ')}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showMedicationActions(int medicationId, String specificTime) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(77),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Medication Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildActionTile(
              icon: 'edit',
              title: 'Edit Medication',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/add-medicine',
                  arguments: medicationId,
                ).then((_) => _loadMedications());
              },
            ),
            _buildActionTile(
              icon: 'snooze',
              title: 'Snooze Reminder',
              onTap: () {
                Navigator.pop(context);
                // Snooze reminder logic (medicationId, specificTime)
              },
            ),
            _buildActionTile(
              icon: 'delete',
              title: 'Delete Medication',
              onTap: () {
                Navigator.pop(context);
                // Delete medication logic (medicationId, specificTime)
              },
              isDestructive: true,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        size: 24,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
