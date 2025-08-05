import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class HealthMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? trend; // 'up', 'down', or 'stable'
  final String iconName;

  const HealthMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withAlpha(26),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              if (trend != null) _buildTrendIndicator(trend!),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 0.5.h),
            Text(
              subtitle!,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(153),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(String trend) {
    IconData iconData;
    Color iconColor;

    switch (trend) {
      case 'up':
        iconData = Icons.trending_up;
        iconColor = AppTheme.lightTheme.colorScheme.tertiary; // Success green
        break;
      case 'down':
        iconData = Icons.trending_down;
        iconColor = AppTheme.lightTheme.colorScheme.error; // Error red
        break;
      case 'stable':
      default:
        iconData = Icons.trending_flat;
        iconColor = AppTheme.lightTheme.colorScheme.onSurface.withAlpha(153);
        break;
    }

    return Icon(iconData, size: 5.w, color: iconColor);
  }
}
