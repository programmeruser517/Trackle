import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'home.dart';
import 'overlay_widget.dart';

void main() {
  runApp(const MyApp());
}

// Initialize the notifications plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trackle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 51, 96, 101)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _showPersistentNotification(); // Show the notification when app starts
  }

  // Initialize notification settings
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) =>
          _onSelectNotification(response), // Handle button clicks
    );
  }

  // Show persistent notification with buttons
  void _showPersistentNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'persistent_notification_channel', // Channel ID
      'Persistent Notification', // Channel name
      channelDescription:
          'This is a persistent notification', // Channel description
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true, // Make it persistent
      styleInformation: BigTextStyleInformation(''),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'location_action',
          'Location',
        ),
        AndroidNotificationAction(
          'camera_action',
          'Camera',
        ),
        AndroidNotificationAction(
          'mic_action',
          'Mic',
        ),
      ],
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Trackle Permissions',
      'Control permissions for Location, Camera, and Mic',
      platformChannelSpecifics,
    );
  }

  Future<void> _onSelectNotification(NotificationResponse response) async {
    final String? actionId = response.actionId;  // Use actionId to determine which button was clicked
    if (actionId != null && actionId.isNotEmpty) {  // Safely check for null and emptiness
      print("Notification actionId: $actionId");

      switch (actionId) {
        case 'location_action':
          _showSnackBar("Location permission clicked");
          break;
        case 'camera_action':
          _showSnackBar("Camera permission clicked");
          break;
        case 'mic_action':
          _showSnackBar("Mic permission clicked");
          break;
        default:
          _showSnackBar("Unknown action clicked");
      }
    }
  }


  // Show a snackbar to display button action feedback
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 51, 96, 101),
      body: Center(
        child: Text(
          'App is running...',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
