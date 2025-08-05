import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mtcare/firebase_options.dart';
import 'package:mtcare/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../widgets/custom_error_widget.dart';
import 'core/app_export.dart';

final notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Main: Firebase initialized successfully.');
  } catch (e) {
    debugPrint('Main: Error initializing Firebase: $e');
    // Optionally, show an error message to the user or log to a crash reporting service
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error initializing Firebase')),
        ),
      ),
    );
    return;
  }

  debugPrint('Main: App starting...');
  await dotenv.load();

  debugPrint('Main: Initializing notification service...');
  await notificationService.init();

  if (!kIsWeb) {
    debugPrint('Main: Requesting permissions...');
    await Permission.storage.request();
    await Permission.scheduleExactAlarm.request();
    await Permission.notification.request();
  }

  ErrorWidget.builder = (FlutterErrorDetails details) {
    debugPrint(
      'Main: Error caught by ErrorWidget.builder: ${details.exception}',
    );
    return CustomErrorWidget(errorDetails: details);
  };

  debugPrint('Main: Loading SharedPreferences...');
  await SharedPreferences.getInstance();

  debugPrint('Main: Setting preferred orientations...');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  debugPrint('Main: Running MyApp...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'mtt_care_giver_assistant',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRoutes.generateRoute,
          initialRoute: AppRoutes.initial,
        );
      },
    );
  }
}
