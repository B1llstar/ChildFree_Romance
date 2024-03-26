import 'package:badges/badges.dart' as badges;
import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:childfree_romance/Notifiers/user_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'Auth/login.dart';
import 'Cards/matchesWidget.dart';
import 'Screens/Settings/Tiles/settings_service.dart';
import 'Screens/Settings/settings_view.dart';
import 'Utils/feedback_service.dart';
import 'card_swiper.dart';
import 'card_swiper_friendship.dart';
import 'firebase_options.dart';

AllUsersNotifier? _allUsersNotifier;

devSignIn() async {
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: "dev@gmail.com", password: "testing");
}

Future<void> baconSignIn() async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: "crigne4lyfe@gmail.com", password: "crigne");
}

// Convert Prompt Format
// List of Prompts -> prompt_1, prompt_2 etc.
Future<void> fetchDataAndUpdateProfile() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    querySnapshot.docs.forEach((DocumentSnapshot document) async {
      Map<String, dynamic>? data =
          document.data() as Map<String, dynamic>?; // Explicit casting
      if (data != null) {
        List<Map<String, dynamic>> prompts =
            List<Map<String, dynamic>>.from(data['prompts'] ?? []);
        if (prompts.isNotEmpty) {
          Map<String, dynamic> prompt3 = {}; // Empty map for prompt_3
          if (prompts.length >= 1) {
            document.reference.update({'prompt_1': prompts[0]});
          }
          if (prompts.length >= 2) {
            document.reference.update({'prompt_2': prompts[1]});
          }
          document.reference.update({'prompt_3': prompt3}); // Update prompt_3
        }
      }
    });
  } catch (error) {
    print("Error retrieving data: $error");
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  String title = message.notification!.title ?? 'You have a notification!';
  BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      title,
      htmlFormatBigText: true,
      contentTitle: title,
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
  await flutterLocalNotificationsPlugin.show(
      0, message.data['title'], message.data['body'], platformChannelSpecifics,
      payload: message.data['body']);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await baconSignIn();
/*
  if (kIsWeb)
    await devSignIn();
  else
    await baconSignIn();

  // Helper Method
  // fetchDataAndUpdateProfile();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  // await duplicateDocument(uid);
  print('UID:  $uid');
  _allUsersNotifier = AllUsersNotifier();
  _allUsersNotifier!.init(uid);
  // Get the initial pool
  // Get the current user
  MatchmakingNotifier matchmakingNotifier =
      MatchmakingNotifier(uid, _allUsersNotifier!);
  // Start the matchmaking service
  MatchService _service = MatchService();
  FirestoreRefactoringService _refactoringService =
      FirestoreRefactoringService();
  _refactoringService.setUsersVisibleProperty();
  // Define Romance & Friendship Matches, as well as pool containing the two
*/
  // print(uid);
  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    title: 'Childfree Connection',
    home: LoginPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Navigation Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => _allUsersNotifier),
          ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ],
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int startingIndex;
  MyHomePage({
    Key? key,
    this.startingIndex = 0,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _selectedItemPosition; // Define _selectedItemPosition in the state
  List<Widget> _pages = [
    CardView(),
    CardViewFriendship(),
    MatchesWidget(),
    SettingsView(),
  ];
  @override
  void initState() {
    super.initState();
    _selectedItemPosition =
        widget.startingIndex; // Initialize _selectedItemPosition in initState

    initInfo();
  }

  void onDidReceiveNotificationResponse(
      BuildContext context, NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {}
  }

  initInfo() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    print('Initializing Messenger services...');
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
      onDidReceiveNotificationResponse(context, response);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('On Message Opened App has been called');
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('On Message has been called');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      String title = message.notification?.title ?? 'title';
      print(message.data);
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          title,
          htmlFormatBigText: true,
          contentTitle: title,
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

      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.data['body'], platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  @override
  Widget build(BuildContext context) {
    AllUsersNotifier _notifier = Provider.of<AllUsersNotifier>(context);
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          width: 600, // Limiting the width to a maximum of 800

          decoration: BoxDecoration(
            color: _notifier.darkMode ? Colors.white : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SalomonBottomBar(
            currentIndex: _notifier.selectedItemPosition,
            onTap: (i) => setState(() => _notifier.selectedItemPosition =
                i), // Update _notifier.selectedItemPosition when tapped
            items: [
              SalomonBottomBarItem(
                icon: Icon(FontAwesomeIcons.heart),
                title: Text('Romance'),
              ),
              SalomonBottomBarItem(
                icon: Icon(FontAwesomeIcons.smile),
                title: Text('Friendship'),
              ),
              SalomonBottomBarItem(
                icon: badges.Badge(
                    badgeContent: Consumer<MatchService>(
                        builder: (context, notifier, child) {
                      return Text(notifier.matches.length.toString(),
                          style: TextStyle(color: Colors.white));
                    }),
                    child: Icon(FontAwesomeIcons.fire)),
                title: Text('Matches'),
              ),
              SalomonBottomBarItem(
                icon: Icon(FontAwesomeIcons.user),
                title: Text('Profile'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor:
          _notifier.darkMode ? Color(0xFF222222) : Color(0xFFA6E7FF),
      appBar: AppBar(
        leading: Row(
          children: [
            GestureDetector(
                onTap: () {
                  _showFeedbackDialog(context);
                },
                child: Image.asset('assets/cfc_logo_med_2.png')),
            SizedBox(width: 4),
            Text('<- Tap for feedback')
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.moon),
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
          ),
          Switch(
              value: _notifier.darkMode,
              onChanged: (value) {
                setState(() {
                  _notifier.darkMode = value;
                });
              }),
        ],
      ),
      body: _pages[_notifier.selectedItemPosition],
    );
  }
}

Future<void> _showFeedbackDialog(BuildContext context) async {
  TextEditingController _feedbackController = TextEditingController();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Provide Feedback'),
        content: TextField(
          controller: _feedbackController,
          decoration: InputDecoration(hintText: 'Enter your feedback'),
          maxLines: 3,
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Submit'),
            onPressed: () {
              String feedback = _feedbackController.text;
              if (feedback.isNotEmpty) {
                FeedbackService feedbackService = FeedbackService();
                feedbackService.submitFeedback(feedback);
                Navigator.of(context).pop();
              }
            },
          ),
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
