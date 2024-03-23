import 'package:childfree_romance/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

import '../Notifiers/all_users_notifier.dart';
import '../Notifiers/user_notifier.dart';
import '../Screens/Settings/Tiles/settings_service.dart';
import '../Services/matchmaking_service.dart';
import '../Utils/debug_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  _createUserInFirestore(SignupData data) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userDocRef.set({
        'email': data.name,
        'aboutMe': '',
        'desiredGenderFriendship': 'Any',
        'desiredGenderRomance': 'Any',
        'does420': '',
        'dopesDrink': '',
        'doesSmoke': '',
        'dreamPartner': '',
        'gender': '',
        'genderToShow': 'Any',
        'isLookingFor': 'Any',
        'isSterilized': '',
        'name': '',
        'profilePictures': [],
        'prompt_1': {},
        'prompt_2': {},
        'prompt_3': {},
        'selectedInterests': [],
        'userId': user.uid,
        'visible': false,
        'willDoLongDistance': 'Yes',
        'willRelocate': 'Maybe'
      });
    }
  }

  Future<String?> _authUser(LoginData data) async {
    try {
      // Perform sign in with Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );

      // After successful sign-in, return null to indicate success
      return null;
    } catch (error) {
      // Return an error message if authentication fails
      DebugUtils.printDebug('Invalid credentials: $error');
      return 'Invalid credentials';
    }
  }

  Future<void> _performSignUp(SignupData data) async {
    try {
      // Perform sign up
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );

      // Create user in Firestore
      await _createUserInFirestore(data);
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Initialize AllUsersNotifier
      AllUsersNotifier _allUsersNotifier = AllUsersNotifier();
      _allUsersNotifier.init(uid);

      // Initialize MatchmakingNotifier
      MatchmakingNotifier matchmakingNotifier =
          MatchmakingNotifier(uid, _allUsersNotifier);

      // Initialize MatchService
      MatchService _service = MatchService();

      // Navigate to the home page with providers
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => UserDataProvider()),
              ChangeNotifierProvider(create: (_) => _allUsersNotifier),
              ChangeNotifierProvider(create: (_) => matchmakingNotifier),
              ChangeNotifierProvider(create: (_) => _service),
              // Add more providers if needed
            ],
            child: MyHomePage(startingIndex: 3),
          ),
        ),
        // Navigate to profile setup screen
      );
    } catch (error) {
      DebugUtils.printDebug('Sign-up failed: $error');
      throw 'Sign-up failed. Please try again.'; // Use throw to propagate the error
    }
  }

  Future<void> _handleSuccessfulLogin(BuildContext context) async {
    try {
      // Clear existing preferences
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Initialize AllUsersNotifier
      AllUsersNotifier _allUsersNotifier = AllUsersNotifier();
      _allUsersNotifier.init(uid);

      // Initialize MatchmakingNotifier
      MatchmakingNotifier matchmakingNotifier =
          MatchmakingNotifier(uid, _allUsersNotifier);

      // Initialize MatchService
      MatchService _service = MatchService();

      // Navigate to the home page with providers
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => UserDataProvider()),
              ChangeNotifierProvider(create: (_) => _allUsersNotifier),
              ChangeNotifierProvider(create: (_) => matchmakingNotifier),
              ChangeNotifierProvider(create: (_) => _service),
              // Add more providers if needed
            ],
            child: MyHomePage(startingIndex: 0),
          ),
        ),
      );
    } catch (error) {
      // Handle errors
      print("Error during successful login: $error");
      // You can show a snackbar, dialog, or navigate to an error page
      // to inform the user about the error and provide appropriate actions.
    }
  }

  Future<String?> _recoverPassword(String email) async {
    try {
      // Use Firebase Authentication to send a pa`ssword reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return null; // Return null to indicate password recovery initiated successfully
    } catch (e) {
      return 'Password recovery failed. Please try again.'; // Return an error message for any errors during password recovery
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA6E7FF),
      body: Container(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Expanded(
                child: FlutterLogin(
                  termsOfService: [
                    TermOfService(
                      id: 'TOS',
                      text: 'I am over the age of 18.',
                      mandatory: true,
                    ),
                    TermOfService(
                      id: 'TOS',
                      text:
                          'Practical AI LLC and its subsidiaries are not responsible for any of my interactions on Childfree Connection.',
                      mandatory: true,
                    ),
                  ],
                  logo: 'assets/cfc_logo_med_2.png',
                  title: kIsWeb
                      ? '  Childfree\nConnection'
                      : '  Childfree\nConnection',
                  headerWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Text('Welcome to the Closed Beta!'),
                            ],
                          )),
                    ],
                  ),
                  theme: LoginTheme(
                      primaryColor: Colors.blue,
                      cardTheme: CardTheme(),
                      cardInitialHeight: 150,
                      titleStyle: TextStyle(color: Colors.black)),
                  onLogin: (loginData) async {
                    String? loginError = await _authUser(loginData);
                    if (loginError == null) {
                      // Login successful, check Privacy Policy acceptance and navigate accordingly

                      await _handleSuccessfulLogin(context);
                    }
                    return loginError;
                  },
                  onSignup: (signupData) async {
                    try {
                      await _performSignUp(signupData);
                      // Signup was successful; navigate to the VerifyEmailPage
                    } catch (error) {
                      // Handle the signup error here (e.g., display an error message)
                    }
                    return null;
                  },
                  onRecoverPassword: (email) {
                    _recoverPassword(email);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
