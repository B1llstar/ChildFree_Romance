import 'package:childfree_romance/Screens/User/upload_profile_picture.dart';
import 'package:childfree_romance/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Notifiers/user_notifier.dart';
import 'Screens/EasyIntro/DrinkSmoke420Interests.dart';
import 'Utils/debug_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DebugUtils.printDebug('Firebase has been initialized.');
  UserDataProvider _userDataProvider = UserDataProvider();
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: "dev@gmail.com", password: "testing");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                _userDataProvider), // Add more providers for other notifiers
        // Add more ChangeNotifierProviders for other notifiers if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.red,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          ProfilePictureUpload(
            onNextPressed: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
          ),
          QuestionPage()
          // Add your QuestionPage here
          // Example:
          // QuestionPage(),
        ],
      ),
    );
  }
}
