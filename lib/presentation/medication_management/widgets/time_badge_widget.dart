import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimeBadgeWidget extends StatelessWidget {
  final String time;
  final String timeType;

  const TimeBadgeWidget({
    super.key,
    required this.time,
    required this.timeType,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    Color textColor;
    String displayText = time;

    switch (timeType.toLowerCase()) {
      case 'morning':
        badgeColor = Color(0xFFFFF3E0); // Light orange
        textColor = Color(0xFFE65100); // Dark orange
        break;
      case 'noon':
        badgeColor = Color(0xFFF3E5F5); // Light purple
        textColor = Color(0xFF4A148C); // Dark purple
        break;
      case 'night':
        badgeColor = Color(0xFFE8F5E8); // Light green
        textColor = Color(0xFF1B5E20); // Dark green
        break;
      default:
        badgeColor = AppTheme.lightTheme.colorScheme.surfaceContainerHighest;
        textColor = AppTheme.lightTheme.colorScheme.onSurface;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: _getTimeIcon(timeType),
            color: textColor,
            size: 14,
          ),
          SizedBox(width: 4),
          Text(
            displayText,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeIcon(String timeType) {
    switch (timeType.toLowerCase()) {
      case 'morning':
        return 'wb_sunny';
      case 'noon':
        return 'wb_sunny_outlined';
      case 'night':
        return 'nights_stay';
      default:
        return 'schedule';
    }
  }
}
