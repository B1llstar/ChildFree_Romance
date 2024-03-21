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
import '../main_w_navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _createUserInFirestore(SignupData data) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userDocRef.set({
        'email': data.name,
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
      _createUserInFirestore(data);

      // Navigate to profile setup screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  startingIndex: 3,
                )),
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
              ChangeNotifierProvider.value(value: _allUsersNotifier),
              ChangeNotifierProvider.value(value: matchmakingNotifier),
              ChangeNotifierProvider.value(value: _service),
              // Add more providers if needed
            ],
            child: MyHomePage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Expanded(
                child: FlutterLogin(
                  logo: 'assets/cfc_logo_med_2.png',
                  title: kIsWeb
                      ? '  Childfree\nConnection'
                      : '  Childfree\nConnection',
                  headerWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('Sign up and get early access!')),
                    ],
                  ),
                  theme: LoginTheme(
                      cardTheme: CardTheme(),
                      cardInitialHeight: 150,
                      titleStyle: TextStyle(color: Colors.white)),
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
                  onRecoverPassword: (String) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
