import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> scheduleNotification(
      {
      required int id,
      required String title,
      required String body,
      required DateTime scheduledTime,
      String? soundPath}) async {
    AndroidNotificationSound? notificationSound;
    if (soundPath != null) {
      if (soundPath.startsWith('assets/')) {
        final fileName = soundPath.split('/').last.split('.').first;
        notificationSound = RawResourceAndroidNotificationSound(fileName);
      } else {
        notificationSound = UriAndroidNotificationSound(soundPath);
      }
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics = 
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      sound: notificationSound,
      playSound: true,
    );
    final NotificationDetails platformChannelSpecifics = 
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, body, tz.TZDateTime.from(scheduledTime, tz.local), platformChannelSpecifics, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }
}
