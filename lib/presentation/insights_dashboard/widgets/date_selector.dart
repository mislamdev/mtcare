import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class DateSelector extends StatelessWidget {
  final String dateRange;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String period; // 'week', 'month', 'year'
  final Function(String) onPeriodChanged;

  const DateSelector({
    super.key,
    required this.dateRange,
    required this.onPrevious,
    required this.onNext,
    required this.period,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'arrow_back_ios',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                onPressed: onPrevious,
              ),
              Text(
                dateRange,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                onPressed: onNext,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _periodButton('Week', 'week'),
              SizedBox(width: 2.w),
              _periodButton('Month', 'month'),
              SizedBox(width: 2.w),
              _periodButton('Year', 'year'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _periodButton(String label, String value) {
    final bool isSelected = period == value;
    return ElevatedButton(
      onPressed: () => onPeriodChanged(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.surface,
        foregroundColor: isSelected
            ? AppTheme.lightTheme.colorScheme.onPrimary
            : AppTheme.lightTheme.colorScheme.primary,
        elevation: isSelected ? 2 : 0,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Text(label),
    );
  }
}
