import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './pending_medications_widget.dart';
import './completed_medications_widget.dart';

class TodaysMedicationsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> medications;
  final Function(int, String) onMedicationToggle;
  final Function(int, String) onMedicationLongPress;

  const TodaysMedicationsWidget({
    super.key,
    required this.medications,
    required this.onMedicationToggle,
    required this.onMedicationLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pendingMedications =
        medications.where((med) => med['isTaken'] == false).toList();
    final List<Map<String, dynamic>> takenMedications =
        medications.where((med) => med['isTaken'] == true).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Today\'s Medications',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${takenMedications.length}/${pendingMedications.length + takenMedications.length} taken',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        PendingMedicationsWidget(
          medications: pendingMedications,
          onMedicationToggle: onMedicationToggle,
          onMedicationLongPress: onMedicationLongPress,
        ),
        SizedBox(height: 2.h),
        CompletedMedicationsWidget(
          medications: takenMedications,
          onMedicationToggle: onMedicationToggle,
          onMedicationLongPress: onMedicationLongPress,
        ),
        if (medications.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const CustomIconWidget(
                  iconName: 'medication',
                  size: 48,
                ),
                SizedBox(height: 2.h),
                Text(
                  'No medications scheduled for today',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Tap the + button to add your first medication',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }
}