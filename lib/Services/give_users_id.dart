import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: "dev@gmail.com", password: "testing");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button Demo',
      home: ButtonWidget(),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  void onPressedMethod() {
    print('Button pressed!');
    assignUserId(); // Call the method from UserService here
  }

  Future<void> assignUserId() async {
    await assignUserIdToUsers();
    print('User IDs assigned successfully!');
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> assignUserIdToUsers() async {
    try {
      QuerySnapshot querySnapshot = await usersCollection.get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String userId = docSnapshot.id;
        Map<String, dynamic> userData =
            docSnapshot.data() as Map<String, dynamic>;

        // Merge 'userId' property with existing properties
        userData['userId'] = userId;

        // Update the document with the merged properties
        await usersCollection
            .doc(userId)
            .set(userData, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error assigning userId to users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Widget'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: onPressedMethod,
          child: Text('Assign User IDs'),
        ),
      ),
    );
  }
}
