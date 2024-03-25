import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'firebase_options.dart';
import 'main.dart';

class FirebaseMessagingTesting extends StatefulWidget {
  const FirebaseMessagingTesting({Key? key}) : super(key: key);

  @override
  State<FirebaseMessagingTesting> createState() =>
      _FirebaseMessagingTestingState();
}

class _FirebaseMessagingTestingState extends State<FirebaseMessagingTesting> {
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    _getAndUploadFCMToken();
    initInfo();
    sendPushNotification(
        "K0kkOLP9zqhdBRyQD1Jy5A0UZzg2", "I am", "Gay", "test", "0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Messaging Testing'),
      ),
      body: Column(
        children: [
          TextField(controller: username),
          TextField(controller: title),
          TextField(controller: body),
        ],
      ),
    );
  }

  Future<void> requestPermission() async {
    // Instantiate FB Messaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> sendPushNotification(String userId, String messageTitle,
      String messageBody, String type, String id) async {
    try {
      // Define the URL of your Cloud Function
      final url =
          'https://us-central1-childfree-connection.cloudfunctions.net/sendPushNotification';

      // Define the request body
      final body = json.encode({
        'userId': userId,
        "title": messageTitle,
        "body": messageBody,
        "type": type,
        "id": id
      });

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
  }

  initInfo() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('On Message has been called');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print(message.data);
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.data['title'],
          htmlFormatBigText: true,
          contentTitle: message.data['title'],
          htmlFormatContentTitle: true);

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('cfc', 'cfc',
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              priority: Priority.high,
              playSound: true);

      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: DarwinNotificationDetails());

      await flutterLocalNotificationsPlugin.show(0, message.data['title'],
          message.data['body'], platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyHomePage(
          startingIndex: 2,
        );
      }));
    }
  }

  Future<void> _getAndUploadFCMToken() async {
    try {
      print('Getting token');
      FirebaseFirestore _db = FirebaseFirestore.instance;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null) {
        var tokens =
            _db.collection('users').doc(uid).collection('tokens').doc(fcmToken);
        print('Token: $tokens');
        await tokens.set({
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'platform': Platform.operatingSystem // optional
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Messaging',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseMessagingTesting(),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body!,
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatContentTitle: true);

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('cfc', 'cfc',
          importance: Importance.high,
          styleInformation: bigTextStyleInformation,
          priority: Priority.high,
          playSound: true);

  NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails());
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
      message.notification!.body, platformChannelSpecifics,
      payload: message.data['body']);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: 'dev@gmail.com',
    password: 'testing',
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}
