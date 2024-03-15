import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:childfree_romance/Notifiers/user_notifier.dart';
import 'package:childfree_romance/Screens/Settings/Tiles/settings_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'Screens/Settings/settings_view.dart';
import 'Screens/chat_widget.dart';
import 'Screens/match_screen.dart';
import 'Services/matchmaking_service.dart';
import 'card_swiper.dart';
import 'firebase_options.dart';

AllUsersNotifier? _allUsersNotifier;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: "dev@gmail.com", password: "testing");
  final uid = FirebaseAuth.instance.currentUser!.uid;
  _allUsersNotifier = AllUsersNotifier();
  // Get the initial pool
  // Get the current user
  MatchmakingNotifier matchmakingNotifier =
      MatchmakingNotifier(uid, _allUsersNotifier!);
  SettingsService _settingsService = SettingsService();
  _settingsService.init();

  // Start the matchmaking service

  // Define Romance & Friendship Matches, as well as pool containing the two

  print(uid);
  runApp(MaterialApp(
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => _allUsersNotifier),
        ChangeNotifierProvider(create: (_) => matchmakingNotifier),
        // Add more providers if needed
      ],
      child: MyHomePage(),
    ),
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
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedItemPosition = 0;
  bool darkModeEnabled = false;
  List<Widget> _pages = [
    CardView(),
    SettingsView(),
    MatchesListWidget(),
    ChatWidget(
      matchId: '123',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeEnabled ? Colors.black : Colors.deepPurpleAccent,
      appBar: AppBar(
        leading: Switch(
          value: darkModeEnabled,
          onChanged: (val) => setState(() => darkModeEnabled = val),
        ),
        title: Text('Dark Mode'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _pages[_selectedItemPosition],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              width: 800, // Limiting the width to a maximum of 800
              decoration: BoxDecoration(
                color: darkModeEnabled ? Colors.white : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SalomonBottomBar(
                currentIndex: _selectedItemPosition,
                onTap: (i) => setState(() => _selectedItemPosition = i),
                items: [
                  SalomonBottomBarItem(
                    icon: Icon(Icons.card_giftcard),
                    title: Text('Discover'),
                  ),
                  SalomonBottomBarItem(
                    icon: Icon(Icons.compass_calibration),
                    title: Text('Discover'),
                  ),
                  SalomonBottomBarItem(
                    icon: Icon(Icons.person),
                    title: Text('Location'),
                  ),
                  SalomonBottomBarItem(
                    icon: Icon(Icons.chat_bubble),
                    title: Text('Chat'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
