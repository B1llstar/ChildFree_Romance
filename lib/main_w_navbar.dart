import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:childfree_romance/Notifiers/user_notifier.dart';
import 'package:childfree_romance/UserSettings/profile_picture_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:provider/provider.dart';

import 'Screens/Settings/settings_view.dart';
import 'firebase_options.dart';

AllUsersNotifier? _allUsersNotifier;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: "dev@gmail.com", password: "testing");
  final uid = FirebaseAuth.instance.currentUser!.uid;
  _allUsersNotifier = AllUsersNotifier();
  _allUsersNotifier!.init(uid);
  print(uid);
  runApp(MyApp());
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

  SnakeShape snakeShape = SnakeShape.circle;
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.pinned;
  ShapeBorder bottomBarShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
  EdgeInsets padding = EdgeInsets.all(12);

  List<Widget> _pages = [SettingsView(), ProfilePicturesPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: Text('Snake Navigation Bar Example'),
      ),
      body: _pages[_selectedItemPosition],
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: snakeBarStyle,
        snakeShape: snakeShape,
        shape: bottomBarShape,
        padding: padding,
        snakeViewColor:
            Colors.black, // Change this color according to your preference
        selectedItemColor:
            snakeShape == SnakeShape.indicator ? Colors.black : null,
        unselectedItemColor: Colors.blueGrey,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() => _selectedItemPosition = index),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: 'Location'),
        ],
      ),
    );
  }
}
