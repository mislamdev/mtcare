import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;
  final String iconName;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      secondary: CustomIconWidget(
        iconName: iconName,
        size: 24,
        color: AppTheme.lightTheme.colorScheme.primary,
      ),
      activeColor: AppTheme.lightTheme.colorScheme.primary,
      activeTrackColor: AppTheme.lightTheme.colorScheme.primary.withAlpha(102),
    );
  }
}
