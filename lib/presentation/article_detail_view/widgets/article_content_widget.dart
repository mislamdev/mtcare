import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ArticleContentWidget extends StatelessWidget {
  final String content;
  final double fontSize;

  const ArticleContentWidget({
    super.key,
    required this.content,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      content,
      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
        fontSize: fontSize,
        height: 1.5,
      ),
    );
  }
}
