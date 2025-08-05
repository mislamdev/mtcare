import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String day;
  final VoidCallback onAddMedicine;

  const EmptyStateWidget({
    super.key,
    required this.day,
    required this.onAddMedicine,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'medication',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 60,
              ),
            ),
            SizedBox(height: 24),

            // Title
            Text(
              day == 'today'
                  ? 'No medications for today'
                  : 'No medications for tomorrow',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),

            // Subtitle
            Text(
              day == 'today'
                  ? 'You\'re all caught up! Add your medications to stay on track with your health routine.'
                  : 'Plan ahead by adding tomorrow\'s medications now.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),

            // Call to action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAddMedicine,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text('Add Your First Medication'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Secondary action
            TextButton.icon(
              onPressed: () {
                // Navigate to medication tips or help
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Medication tips coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: CustomIconWidget(
                iconName: 'help_outline',
                color: AppTheme.lightTheme.primaryColor,
                size: 18,
              ),
              label: Text('Learn about medication management'),
            ),
          ],
        ),
      ),
    );
  }
}
