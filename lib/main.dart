import 'package:badges/badges.dart' as badges;
import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:childfree_romance/Notifiers/user_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'Auth/login.dart';
import 'Cards/matchesWidget.dart';
import 'Screens/Settings/Tiles/settings_service.dart';
import 'Screens/Settings/settings_view.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
            currentIndex: _selectedItemPosition,
            onTap: (i) => setState(() => _selectedItemPosition =
                i), // Update _selectedItemPosition when tapped
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
                  print('Tapped');
                },
                child: Image.asset('assets/cfc_logo_med_2.png')),
            Text('Click me to provide feedback!')
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
      body: _pages[_selectedItemPosition],
    );
  }
}
