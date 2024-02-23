import 'package:childfree_romance/Screens/profile_setup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';
import '../Utils/debug_utils.dart';

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

      // Clear existing preferences
      ProfileSetupNotifier profileSetupNotifier =
          Provider.of<ProfileSetupNotifier>(context, listen: false);
      profileSetupNotifier.clearPreferences();

      // Create user in Firestore
      _createUserInFirestore(data);

      // Navigate to profile setup screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
      );
    } catch (error) {
      DebugUtils.printDebug('Sign-up failed: $error');
      throw 'Sign-up failed. Please try again.'; // Use throw to propagate the error
    }
  }

  Future<void> _handleSuccessfulLogin() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProfileSetupScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Expanded(
                child: FlutterLogin(
                  title: 'Child-Free\nRomance',
                  theme: LoginTheme(
                      cardInitialHeight: 150,
                      pageColorDark: Colors.purple,
                      titleStyle: TextStyle(color: Colors.white)),
                  onLogin: (loginData) async {
                    String? loginError = await _authUser(loginData);
                    if (loginError == null) {
                      // Login successful, check Privacy Policy acceptance and navigate accordingly

                      await _handleSuccessfulLogin();
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
