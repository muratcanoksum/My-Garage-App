// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, avoid_returning_null_for_void

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final onClickNotification = BehaviorSubject<String>();

  // on top on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  // initialize func.
  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) => onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', "your channel name",
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  //to show periodic notification at regular interval
  static Future showPeriodicNotifications({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel $id', "your channel name",
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        id, title, body, RepeatInterval.everyMinute, notificationDetails);
  }

  // to schedule a local notifications
  static Future showScheduleNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required DateTime scheduledDateTime,
  }) async {
    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        NotificationDetails(
            android: AndroidNotificationDetails(
                'channel $id', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }

  // close a specific channel notification
  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // close all the notifications
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // active notifications list
  static Future getList() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (int i = 0; i < pendingNotificationRequests.length; i++) {
      print(pendingNotificationRequests[i].body);
    }
  }
}
