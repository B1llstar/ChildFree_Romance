import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: 'dev@gmail.com',
    password: 'testing',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirestoreDemoPage(),
    );
  }
}

class FirestoreDemoPage extends StatefulWidget {
  @override
  _FirestoreDemoPageState createState() => _FirestoreDemoPageState();
}

class _FirestoreDemoPageState extends State<FirestoreDemoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void getFeedback() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot usersSnapshot = await firestore.collection('users').get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        if (userDoc.exists) {
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?; // Explicit cast
          if (userData != null && userData.containsKey('feedback')) {
            print('User Feedback: ${userData['feedback']}');
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: getFeedback,
          child: Text('Fetch Data'),
        ),
      ),
    );
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot newsletterSnapshot =
          await _firestore.collection('newsletter_signups').get();

      for (QueryDocumentSnapshot newsletterDoc in newsletterSnapshot.docs) {
        String newsletterDocId = newsletterDoc.id;
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(newsletterDocId).get();

        if (userDoc.exists) {
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?; // Explicit cast
          if (userData != null && userData.containsKey('email')) {
            print('User Email: ${userData['email']}');
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
