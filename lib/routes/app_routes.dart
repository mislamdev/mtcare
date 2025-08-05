import 'package:flutter/material.dart';

import '../presentation/add_medicine/add_medicine.dart';
import '../presentation/article_detail_view/article_detail_view.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/info_knowledge_screen/info_knowledge_screen.dart';
import '../presentation/insights_dashboard/insights_dashboard.dart';
import '../presentation/medication_management/medication_management.dart';
import '../presentation/settings_screen/edit_profile_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/steps_tracker/steps_tracker.dart';
import '../presentation/welcome_screen/welcome_screen.dart';

class AppRoutes {
  static const String initial = '/splash-screen';
  static const String splashScreen = '/splash-screen';
  static const String welcomeScreen = '/welcome-screen';
  static const String homeScreen = '/home-screen';
  static const String stepsTracker = '/steps-tracker';
  static const String medicationManagement = '/medication-management';
  static const String addMedicine = '/add-medicine';
  static const String infoKnowledgeScreen = '/info-knowledge-screen';
  static const String articleDetailView = '/article-detail-view';
  static const String settingsScreen = '/settings-screen';
  static const String insightsDashboard = '/insights-dashboard';
  static const String editProfileScreen = '/edit-profile-screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case welcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case stepsTracker:
        return MaterialPageRoute(builder: (_) => const StepsTracker());
      case medicationManagement:
        return MaterialPageRoute(builder: (_) => const MedicationManagement());
      case addMedicine:
        final medicationId = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => AddMedicine(medicationId: medicationId),
        );
      case infoKnowledgeScreen:
        return MaterialPageRoute(builder: (_) => const InfoKnowledgeScreen());
      case articleDetailView:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => ArticleDetailView(
            question: args['question']!,
            answer: args['answer']!,
          ),
        );
      case settingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case insightsDashboard:
        return MaterialPageRoute(builder: (_) => const InsightsDashboard());
      case editProfileScreen:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(
            currentName: args['name']!,
            currentEmail: args['email']!,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
