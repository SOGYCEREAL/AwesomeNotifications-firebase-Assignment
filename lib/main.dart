import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notification/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_notification/pages/home_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //init awesome notification
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'note_channel',
        channelName: 'Note Notifications',
        channelDescription: 'Notifications for note activities',
        defaultColor: Colors.purple,
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
  );

  // asking permission
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // klo udh ada permission
  if (isAllowed) {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 999,
        channelKey: 'note_channel',
        title: 'Test Notification',
        body: 'If you see this, Awesome Notifications works!',
      ),
    );
  }

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}