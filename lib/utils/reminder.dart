import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// The Reminder class is used to schedule reminders.
FlutterLocalNotificationsPlugin notifications;

// The initNotifications method is used to initialize the notifications.
Future<void> initNotifications() async {
  notifications = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher'); // Use the app icon as the notification icon.
  var initializationSettingsIOS =
      IOSInitializationSettings(); // Use the default notification icon.
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS); // Set the initialization settings.
  await notifications.initialize(initializationSettings,
      onSelectNotification:
          (String payload) async {}); // Initialize the notifications.
}

// The scheduleReminder method is used to schedule a reminder.
Future<void> scheduleReminder(DateTime time, String message) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'com.a9883.gymapp',
    'NLP Gym App',
    'NLP Gym App',
    importance: Importance.max,
    priority: Priority.high,
  ); // Set the notification details.
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await notifications.schedule(0, 'Reminder', message, time,
      platformChannelSpecifics); // Schedule the reminder.
}
