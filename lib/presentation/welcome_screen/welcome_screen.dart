import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/feature_highlight_card_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),

              // App Logo with First-Aid Kit Branding
              _buildAppLogo(),

              SizedBox(height: 6.h),

              // Welcome Headline
              _buildWelcomeHeadline(),

              SizedBox(height: 3.h),

              // Descriptive Text
              _buildDescriptiveText(),

              SizedBox(height: 6.h),

              // Feature Highlight Cards
              _buildFeatureHighlightCards(),

              SizedBox(height: 8.h),

              // Get Started Button
              _buildGetStartedButton(context),

              SizedBox(height: 2.h),

              // Skip Option
              _buildSkipOption(context),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.primary.withValues(
              alpha: 0.3,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'medical_services',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 12.w,
        ),
      ),
    );
  }

  Widget _buildWelcomeHeadline() {
    return Text(
      'Welcome to Care Giver Assistant',
      textAlign: TextAlign.center,
      style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.colorScheme.onSurface,
        height: 1.2,
      ),
    );
  }

  Widget _buildDescriptiveText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        'Your comprehensive healthcare companion for medication tracking, health monitoring, and caregiver support. Stay on top of your health with smart reminders and insights.',
        textAlign: TextAlign.center,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildFeatureHighlightCards() {
    final List<Map<String, dynamic>> features = [
      {
        'icon': 'medication',
        'title': 'Medication Reminders',
        'description':
            'Never miss a dose with smart notifications and tracking',
      },
      {
        'icon': 'directions_walk',
        'title': 'Step Tracking',
        'description':
            'Monitor your daily activity and reach your fitness goals',
      },
      {
        'icon': 'article',
        'title': 'Health Articles',
        'description':
            'Access curated health content and educational resources',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: EdgeInsets.only(bottom: 3.h),
          child: FeatureHighlightCardWidget(
            iconName: feature['icon'] as String,
            title: feature['title'] as String,
            description: feature['description'] as String,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 7.h,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/home-screen');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          elevation: 4,
          shadowColor: AppTheme.lightTheme.colorScheme.primary.withValues(
            alpha: 0.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Get Started',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildSkipOption(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/home-screen');
      },
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      ),
      child: Text(
        'Skip',
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
