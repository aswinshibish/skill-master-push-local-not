

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized properly
  await Firebase.initializeApp(); // Initializes Firebase
  runApp(MyApp()); // Runs the app
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides debug banner
      title: 'Flutter Push Notification',
      home: HomeScreen(), // Sets HomeScreen as the first screen
    );
  }
}
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _notifications = FlutterLocalNotificationsPlugin(); // Local notifications plugin instance

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission(); // Requests notification permission from user
    FirebaseMessaging.instance.getToken().then((token) => print("Token: $token")); // Retrieves and prints device token
    _initNotifications(); // Initializes local notifications
    FirebaseMessaging.onMessage.listen(_showNotification); // Listens for incoming messages when the app is open
  }

  void _initNotifications() {
    _notifications.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'), // Sets default notification icon
    ));
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final androidDetails = AndroidNotificationDetails(
      'channel_id', 'Notifications',
      importance: Importance.high, // Ensures high-priority notifications
    );
await _notifications.show(
      0, // Notification ID (used to update or cancel specific notifications)
      message.notification?.title, // Notification title
      message.notification?.body, // Notification body
      NotificationDetails(android: androidDetails), // Platform-specific details
    );
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Sets app bar color
        title: Text('Push Notifications'), // Sets app bar title
      ),
      body: Center(
        child: Text('Waiting for notifications...'), // Displays a message
      ),
    );
  }
}