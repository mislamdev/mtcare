import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import './time_badge_widget.dart';

class MedicationCardWidget extends StatelessWidget {
  final Map<String, dynamic> medication;
  final VoidCallback onTaken;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSnooze;
  final VoidCallback onLongPress;

  const MedicationCardWidget({
    super.key,
    required this.medication,
    required this.onTaken,
    required this.onEdit,
    required this.onDelete,
    required this.onSnooze,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTaken = medication["taken"] as bool;
    final String timeType = medication["timeType"] as String;
    final String shape = medication["shape"] as String;
    final String pillColor = medication["color"] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(medication["id"].toString()),
        background: _buildSwipeBackground(
          color: AppTheme.lightTheme.colorScheme.tertiary,
          icon: 'check',
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: _buildSwipeBackground(
          color: AppTheme.lightTheme.colorScheme.error,
          icon: 'more_horiz',
          alignment: Alignment.centerRight,
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Swipe right - mark as taken
            if (!isTaken) {
              onTaken();
              HapticFeedback.lightImpact();
            }
            return false; // Don't dismiss the card
          } else {
            // Swipe left - show action menu
            _showActionMenu(context);
            return false; // Don't dismiss the card
          }
        },
        child: GestureDetector(
          onLongPress: () {
            HapticFeedback.mediumImpact();
            onLongPress();
          },
          child: Card(
            elevation: isTaken ? 1 : 4,
            color: isTaken
                ? AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                : AppTheme.lightTheme.cardColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: isTaken,
                    onChanged: (bool? value) {
                      if (value != null && value) {
                        onTaken();
                      }
                    },
                    activeColor: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                  SizedBox(width: 16),
                  // Pill shape indicator
                  _buildPillIndicator(shape, pillColor),
                  SizedBox(width: 16),
                  // Medication details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                medication["name"] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                      decoration: isTaken
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: isTaken
                                          ? AppTheme
                                                .lightTheme
                                                .colorScheme
                                                .onSurfaceVariant
                                          : AppTheme
                                                .lightTheme
                                                .colorScheme
                                                .onSurface,
                                    ),
                              ),
                            ),
                            if (isTaken)
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                size: 20,
                              ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          medication["nameBangla"] as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme
                                    .lightTheme
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            TimeBadgeWidget(
                              time: medication["time"] as String,
                              timeType: timeType,
                            ),
                            SizedBox(width: 12),
                            Text(
                              medication["dosage"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: isTaken
                                        ? AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .onSurfaceVariant
                                        : AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .onSurface,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          medication["instructions"] as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme
                                    .lightTheme
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  // Progress indicator
                  _buildProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Color color,
    required String icon,
    required Alignment alignment,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: CustomIconWidget(iconName: icon, color: Colors.white, size: 24),
    );
  }

  Widget _buildPillIndicator(String shape, String colorHex) {
    Color pillColor;
    try {
      pillColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      pillColor = AppTheme.lightTheme.colorScheme.surfaceContainerHighest;
    }

    Widget pillShape;
    switch (shape.toLowerCase()) {
      case 'round':
        pillShape = Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: pillColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
        );
        break;
      case 'oval':
        pillShape = Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
        );
        break;
      case 'capsule':
        pillShape = Container(
          width: 40,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: pillColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      default: // tablet
        pillShape = Container(
          width: 40,
          height: 30,
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
        );
    }

    return pillShape;
  }

  Widget _buildProgressIndicator() {
    final int completed = medication["completedDoses"] as int;
    final int total = medication["totalDoses"] as int;
    final double progress = total > 0 ? completed / total : 0.0;

    return Column(
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.lightTheme.colorScheme.outline,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.tertiary,
            ),
            strokeWidth: 3,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '$completed/$total',
          style: AppTheme.lightTheme.textTheme.labelSmall,
        ),
      ],
    );
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Medication Actions',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 24),
              _buildActionButton(
                context,
                'Edit',
                'edit',
                AppTheme.lightTheme.primaryColor,
                onEdit,
              ),
              SizedBox(height: 12),
              _buildActionButton(
                context,
                'Snooze (15 min)',
                'snooze',
                AppTheme.lightTheme.colorScheme.secondary,
                onSnooze,
              ),
              SizedBox(height: 12),
              _buildActionButton(
                context,
                'Delete',
                'delete',
                AppTheme.lightTheme.colorScheme.error,
                onDelete,
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    String icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pop(context);
          onPressed();
        },
        icon: CustomIconWidget(iconName: icon, color: color, size: 20),
        label: Text(label, style: TextStyle(color: color)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
