import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ArticleProgressIndicator extends StatelessWidget {
  final double progress;

  const ArticleProgressIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress.clamp(0.0, 1.0),
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      valueColor: AlwaysStoppedAnimation<Color>(
          AppTheme.lightTheme.colorScheme.primary),
      minHeight: 3,
    );
  }
}
