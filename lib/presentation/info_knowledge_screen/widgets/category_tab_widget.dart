import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CategoryTabWidget extends StatelessWidget {
  final TabController tabController;
  final List<String> categories;

  const CategoryTabWidget({
    super.key,
    required this.tabController,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor.withAlpha(13),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor:
            AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelLarge,
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        tabs: categories.map((category) => _buildTab(category)).toList(),
        onTap: (index) {
          // Add haptic feedback
          // HapticFeedback.lightImpact();
        },
      ),
    );
  }

  Widget _buildTab(String category) {
    return Tab(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Text(category),
      ),
    );
  }
}
