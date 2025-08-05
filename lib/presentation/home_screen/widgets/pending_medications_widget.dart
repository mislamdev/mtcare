import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PendingMedicationsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> medications;
  final Function(int, String) onMedicationToggle;
  final Function(int, String) onMedicationLongPress;

  const PendingMedicationsWidget({
    super.key,
    required this.medications,
    required this.onMedicationToggle,
    required this.onMedicationLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pending',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 1.h),
          if (medications.isNotEmpty)
            ...medications.map((medication) => _buildMedicationItem(
                  medication: medication,
                  isTaken: medication['isTaken'] as bool,
                  specificTime: medication['specificTime'] as String,
                ))
          else
            _buildEmptyState('No pending medications.'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.6),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMedicationItem({
    required Map<String, dynamic> medication,
    required bool isTaken,
    required String specificTime,
  }) {
    final medicationId = medication["id"] as int;
    final name = medication["name"] as String? ?? "Unknown";
    final dosage = medication["dosage"] as String? ?? "Unknown";
    final type = medication["type"] as String? ?? "tablet";
    final urgency = medication["urgency"] as String? ?? "low";

    final urgencyColor = _getUrgencyColor(urgency);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Dismissible(
        key: Key('medication_${medicationId}_$specificTime'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            color: isTaken
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.successLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: isTaken ? 'undo' : 'check',
            size: 24,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        onDismissed: (direction) {
          onMedicationToggle(medicationId, specificTime);
        },
        child: GestureDetector(
          onLongPress: () => onMedicationLongPress(medicationId, specificTime),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isTaken
                    ? AppTheme.successLight.withOpacity(0.3)
                    : urgencyColor.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => onMedicationToggle(medicationId, specificTime),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color:
                          isTaken ? AppTheme.successLight : Colors.transparent,
                      border: Border.all(
                        color: isTaken ? AppTheme.successLight : urgencyColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: isTaken
                        ? CustomIconWidget(
                            iconName: 'check',
                            size: 16,
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 3.w),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: (isTaken ? AppTheme.successLight : urgencyColor)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getMedicationIcon(type),
                    size: 20,
                    color: isTaken ? AppTheme.successLight : urgencyColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isTaken
                              ? AppTheme.lightTheme.colorScheme.onSurface
                                  .withOpacity(0.6)
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          decoration:
                              isTaken ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        dosage,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withOpacity(0.7),
                          decoration:
                              isTaken ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'access_time',
                          size: 14,
                          color: isTaken ? AppTheme.successLight : urgencyColor,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          specificTime,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color:
                                isTaken ? AppTheme.successLight : urgencyColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (!isTaken) ...[
                      SizedBox(height: 0.5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: urgencyColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          urgency.toUpperCase(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: urgencyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
      default:
        return AppTheme.successLight;
    }
  }

  String _getMedicationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'tablet':
        return 'medication';
      case 'capsule':
        return 'medication';
      case 'softgel':
        return 'medication_liquid';
      case 'liquid':
        return 'medication_liquid';
      case 'injection':
        return 'vaccines';
      default:
        return 'medication';
    }
  }
}
