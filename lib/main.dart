import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
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
    debugPrint(
      'Main: Existing Firebase apps: ${Firebase.apps.map((a) => a.name).join(', ')}',
    );
    // Defensive: try/catch around Firebase.apps to avoid race conditions
    bool alreadyInitialized = false;
    try {
      alreadyInitialized = Firebase.apps.any((a) => a.name == '[DEFAULT]');
    } catch (_) {}
    if (!alreadyInitialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Main: Firebase initialized successfully.');
    } else {
      debugPrint('Main: Firebase already initialized.');
    }
  } catch (e) {
    debugPrint('Main: Error initializing Firebase: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing Firebase:\n\n$e'),
          ),
        ),
      ),
    );
    return;
  }

  debugPrint('Main: App starting...');
  await dotenv.load();

  debugPrint('Main: Initializing notification service...');
  if (Platform.isAndroid || Platform.isIOS) {
    try {
      await notificationService.init();
    } catch (e) {
      debugPrint('Notification service initialization failed: $e');
    }
  } else if (Platform.isLinux) {
    try {
      await notificationService.init();
    } catch (e) {
      debugPrint('Notification service initialization failed: $e');
    }
    debugPrint(
      'Notification service: Linux platform detected. Use a Linux-specific notification package here.',
    );
    // TODO: Initialize Linux-specific notifications if needed
  } else if (Platform.isWindows) {
    debugPrint(
      'Notification service: Windows platform detected. Use a Windows-specific notification package here.',
    );
    // TODO: Initialize Windows-specific notifications if needed
  } else if (Platform.isMacOS) {
    debugPrint(
      'Notification service: macOS platform detected. Use a macOS-specific notification package here.',
    );
    // TODO: Initialize macOS-specific notifications if needed
  }

  // Permissions
  if (Platform.isAndroid || Platform.isIOS) {
    debugPrint('Main: Requesting permissions...');
    await Permission.storage.request();
    await Permission.scheduleExactAlarm.request();
    await Permission.notification.request();
  } else if (Platform.isLinux) {
    debugPrint(
      'Permissions: Linux platform detected. Use a Linux-specific permissions package here if needed.',
    );
    // TODO: Request Linux-specific permissions if needed
  } else if (Platform.isWindows) {
    debugPrint(
      'Permissions: Windows platform detected. Use a Windows-specific permissions package here if needed.',
    );
    // TODO: Request Windows-specific permissions if needed
  } else if (Platform.isMacOS) {
    debugPrint(
      'Permissions: macOS platform detected. Use a macOS-specific permissions package here if needed.',
    );
    // TODO: Request macOS-specific permissions if needed
  } else {
    debugPrint('Permission requests skipped: not Android/iOS.');
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
          title: 'MT Care',
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
