import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class CircularProgressWidget extends StatelessWidget {
  final int currentSteps;
  final int dailyGoal;
  final Animation<double> progressAnimation;

  const CircularProgressWidget({
    super.key,
    required this.currentSteps,
    required this.dailyGoal,
    required this.progressAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 60.w,
        height: 60.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Circle
            SizedBox(
              width: 60.w,
              height: 60.w,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 12,
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.outline.withValues(
                    alpha: 0.1,
                  ),
                ),
              ),
            ),

            // Progress Circle
            AnimatedBuilder(
              animation: progressAnimation,
              builder: (context, child) {
                return SizedBox(
                  width: 60.w,
                  height: 60.w,
                  child: CircularProgressIndicator(
                    value: progressAnimation.value > 1.0
                        ? 1.0
                        : progressAnimation.value,
                    strokeWidth: 12,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progressAnimation.value >= 1.0
                          ? AppTheme.successLight
                          : AppTheme.lightTheme.primaryColor,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                );
              },
            ),

            // Center Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'directions_walk',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  currentSteps.toString(),
                  style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  currentSteps >= dailyGoal ? 'Goal Achieved' : 'steps',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Goal: $dailyGoal',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
