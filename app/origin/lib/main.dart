import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  //options: DefaultFirebaseOptions.currentPlatform,
);
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Push Notification',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
 // const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@override
void initState(){
super.initState();
requestPermission();
setupFirebaseMessaging();
 getDeviceToken();

 AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('');
 InitializationSettings initializationSettings = InitializationSettings(
  android:initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

  void requestPermission() async{
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('Permission granted');
}
    else{
      print('Permission denied');
    }
  }

  void setupFirebaseMessaging(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      print('Received Notification: ${message.notification?.title}');

      if(message.notification != null){
        await _showNotification(
          message.notification?.title,
        message.notification?.body,
        );
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
    print('Background message: ${message.messageId}');
  }

  void getDeviceToken() async{
    String? token = await FirebaseMessaging.instance.getToken();
    print("Device Token : $token");
  }

  Future<void> _showNotification(String? title, String? body) async{
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription : 'your_channel_description',
      importance : Importance.high,
      priority : Priority.high,
    );

    NotificationDetails platformDetails = NotificationDetails(
      android:androidDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
    title,
    body,
    platformDetails,
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Firebase Push notification',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
      ) ,
      body: Center(
        child: Text('Waiting for notification ... '),
      ),
    );
  }
}


// import 'package:firebase_core/firebase_core.dart'; // Import Firebase core package
// import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase messaging package
// import 'package:flutter/material.dart'; // Import Flutter material package
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import local notifications package

// // Background handler for Firebase messaging (must be a top-level function)
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(); // Ensure Firebase is initialized
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is properly initialized
//   await Firebase.initializeApp(); // Initialize Firebase
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // Set background message handler
//   runApp(MyApp()); // Run the application
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, // Hide debug banner
//       title: 'Flutter Push Notification', // Set app title
//       home: HomeScreen(), // Set home screen
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin(); // Initialize local notifications plugin

//   @override
//   void initState() {
//     super.initState();
//     requestPermission(); // Request notification permissions 
//     setupFirebaseMessaging(); // Setup Firebase messaging
//     getDeviceToken(); // Retrieve device token
//     _initializeNotifications(); // Initialize local notifications
//   }

//   void requestPermission() async {
//     await FirebaseMessaging.instance.requestPermission(); // Request user permission for notifications
//   }

//   void setupFirebaseMessaging() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       if (message.notification != null) {
//         _showNotification(message.notification?.title, message.notification?.body); // Show notification if available
//       }
//     });
//   }

//   void getDeviceToken() async {
//     print("Device Token : ${await FirebaseMessaging.instance.getToken()}"); // Print device token for debugging
//   }

//   void _initializeNotifications() async {
//     const AndroidInitializationSettings androidInitialization =
//         AndroidInitializationSettings('@mipmap/ic_launcher'); // Set default app icon for notifications
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: androidInitialization); // Configure initialization settings
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings); // Initialize local notifications
//   }

//   Future<void> _showNotification(String? title, String? body) async {// Notification channels are used in Android  to categorize and manage notifications.
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(//AndroidNotificationDetails defines how the notification should appear on Android.
//       'high_importance_channel', // Notification channel ID  , The channel ID must match the one used in _initializeNotifications() to ensure the system routes the notification correctly.
//       'High Importance Notifications', // Channel name
//       channelDescription: 'This channel is used for important notifications.', // Channel description
//       importance: Importance.high, // Set importance level
//       priority: Priority.high, // Set priority level  , importance and priority are set to high so that the notification appears prominently.
//     ); 
//     await flutterLocalNotificationsPlugin.show(
//       0, // Notification ID, // Notification ID (used to update or cancel a notification)
//       title, // Notification title,  // Notification title (e.g., message title)
//       body, // Notification body, // Notification body (e.g., message content)
//       NotificationDetails(android: androidDetails), // Set notification details, // Platform-specific notification details (Android in this case)
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueGrey, // Set AppBar background color
//         title: Text('Firebase Push Notification', // Set AppBar title
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), // Style AppBar title
//       ),
//       body: Center(child: Text('Waiting for notification...')), // Display waiting message
//     );
//   }
// }
// Use of Notification Channels
// Group notifications under a specific category.
// Ensure notifications appear properly on Android (API 26+).
// Allow users to customize notification settings.
// Set importance and priority for better visibility.
// Without channels, notifications may not work on newer Android versions. 

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   NotificationService.initialize();
//   runApp(AlarmClockApp());
// }

// // 🔔 Notification Service
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize() {
//     final InitializationSettings settings = InitializationSettings(
//       android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//     );

//     _notificationsPlugin.initialize(settings);
//   }

//   static void showNotification(String title, String body) {
//     NotificationDetails details = NotificationDetails(
//       android: AndroidNotificationDetails(
//         "alarm_channel", "Alarm Notifications",
//         importance: Importance.high,
//         priority: Priority.high,
//       ),
//     );

//     _notificationsPlugin.show(0, title, body, details);
//   }
// }

// // 🌙 Alarm Clock App
// class AlarmClockApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: Colors.blue[900], 
//         appBarTheme: AppBarTheme(backgroundColor: Colors.blue[800]),
//       ),
//       home: AlarmClockScreen(),
//     );
//   }
// }

// // ⏰ Alarm Clock Screen
// class AlarmClockScreen extends StatefulWidget {
//   @override
//   _AlarmClockScreenState createState() => _AlarmClockScreenState();
// }

// class _AlarmClockScreenState extends State<AlarmClockScreen> {
//   List<TimeOfDay> alarms = [];

//   void _addAlarm() async {
//     TimeOfDay? selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (selectedTime != null) {
//       setState(() {
//         alarms.add(selectedTime);
//       });

//       // Schedule Notification
//       DateTime now = DateTime.now();
//       DateTime scheduledTime = DateTime(
//         now.year, now.month, now.day, selectedTime.hour, selectedTime.minute,
//       );

//       if (scheduledTime.isBefore(now)) {
//         scheduledTime = scheduledTime.add(Duration(days: 1));
//       }

//       Future.delayed(
//         scheduledTime.difference(now),
//         () => NotificationService.showNotification("Alarm", "It's time for your alarm!"),
//       );
//     }
//   }

//   void _deleteAlarm(int index) {
//     setState(() {
//       alarms.removeAt(index);
//     });
//   }

//   String _formatTime(TimeOfDay time) {
//     final now = DateTime.now();
//     return DateFormat('hh:mm a').format(
//       DateTime(now.year, now.month, now.day, time.hour, time.minute),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Alarm Clock', style: TextStyle(color: Colors.white)), centerTitle: true),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           Text(
//             DateFormat('hh:mm a').format(DateTime.now()),
//             style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: alarms.isEmpty
//                 ? Center(child: Text('No Alarms Set', style: TextStyle(color: Colors.white)))
//                 : ListView.builder(
//                     itemCount: alarms.length,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         color: Colors.blue[700],
//                         child: ListTile(
//                           title: Text(_formatTime(alarms[index]), style: TextStyle(color: Colors.white)),
//                           trailing: IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _deleteAlarm(index),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addAlarm,
//         backgroundColor: Colors.blue[800],
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }//almost correct
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   NotificationService.initialize();
//   runApp(AlarmClockApp());
// }

// // 🔔 Notification Service
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize() {
//     final InitializationSettings settings = InitializationSettings(
//       android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//     );

//     _notificationsPlugin.initialize(settings);
//   }

//   static void showNotification(String title, String body) {
//     NotificationDetails details = NotificationDetails(
//       android: AndroidNotificationDetails(
//         "alarm_channel", "Alarm Notifications",
//         importance: Importance.high,
//         priority: Priority.high,
//       ),
//     );

//     _notificationsPlugin.show(0, title, body, details);
//   }
// }

// // 🌙 Alarm Clock App
// class AlarmClockApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: Colors.blue[900], 
//         appBarTheme: AppBarTheme(backgroundColor: Colors.blue[800]),
//       ),
//       home: AlarmClockScreen(),
//     );
//   }
// }

// // ⏰ Alarm Clock Screen
// class AlarmClockScreen extends StatefulWidget {
//   @override
//   _AlarmClockScreenState createState() => _AlarmClockScreenState();
// }

// class _AlarmClockScreenState extends State<AlarmClockScreen> {
//   List<TimeOfDay> alarms = [];

//   void _addAlarm() async {
//     TimeOfDay? selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (selectedTime != null) {
//       setState(() {
//         alarms.add(selectedTime);
//       });

//       // Schedule Alarm
//       DateTime now = DateTime.now();
//       DateTime scheduledTime = DateTime(
//         now.year, now.month, now.day, selectedTime.hour, selectedTime.minute,
//       );

//       if (scheduledTime.isBefore(now)) {
//         scheduledTime = scheduledTime.add(Duration(days: 1));
//       }

//       Future.delayed(
//         scheduledTime.difference(now),
//         () {
//           NotificationService.showNotification("Alarm", "It's time for your alarm!");
//           _showAlarmPopup(selectedTime);
//         },
//       );
//     }
//   }

//   void _deleteAlarm(int index) {
//     setState(() {
//       alarms.removeAt(index);
//     });
//   }

//   void _showAlarmPopup(TimeOfDay time) {
//     String formattedTime = _formatTime(time);
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         Future.delayed(Duration(seconds: 20), () {
//           if (Navigator.canPop(context)) Navigator.pop(context);
//         });

//         return AlertDialog(
//           title: Text("Alarm Ringing!", style: TextStyle(color: Colors.red, fontSize: 22)),
//           content: Text("Alarm set for $formattedTime is ringing.", style: TextStyle(fontSize: 18)),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Dismiss", style: TextStyle(fontSize: 18)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _formatTime(TimeOfDay time) {
//     final now = DateTime.now();
//     return DateFormat('hh:mm a').format(
//       DateTime(now.year, now.month, now.day, time.hour, time.minute),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Alarm Clock', style: TextStyle(color: Colors.white)), centerTitle: true),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           Text(
//             DateFormat('hh:mm a').format(DateTime.now()),
//             style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: alarms.isEmpty
//                 ? Center(child: Text('No Alarms Set', style: TextStyle(color: Colors.white)))
//                 : ListView.builder(
//                     itemCount: alarms.length,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         color: Colors.blue[700],
//                         child: ListTile(
//                           title: Text(_formatTime(alarms[index]), style: TextStyle(color: Colors.white)),
//                           trailing: IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _deleteAlarm(index),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addAlarm,
//         backgroundColor: Colors.blue[800],
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }
