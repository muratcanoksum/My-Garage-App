// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:toautoapp/home.dart';
import 'package:toautoapp/notification_helper.dart';
import 'package:toautoapp/splashscreen.dart';

int BG_CLR = 0X001A191A;

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

  //  handle in terminated state
  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    // LocalNotifications.onClickNotification.stream.listen((event) {
    Future.delayed(const Duration(seconds: 1), () {
      // print(event);
      navigatorKey.currentState!.pushNamed('/',
          arguments: initialNotification?.notificationResponse?.payload);
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));

    return SafeArea(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'To Auto',
        theme: ThemeData(
          fontFamily: "Gilroy",
          colorScheme: const ColorScheme.dark(),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const Home(),
        },
      ),
    );
  }
}
