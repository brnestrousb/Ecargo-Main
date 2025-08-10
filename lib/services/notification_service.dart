import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification'); // Tanpa .png

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    icon: 'ic_notification', // TANPA .png
    largeIcon: DrawableResourceAndroidBitmap('app_icon'),
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Judul Notifikasi',
    'Isi pesan notifikasi',
    platformChannelSpecifics,
  );
}
