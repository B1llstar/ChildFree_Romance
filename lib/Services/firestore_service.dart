import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadUserData(Map<String, dynamic> userData) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      print('Current user: $user');
      if (user != null) {
        String userId = user.uid;

        // Get null properties
        List<String> nullProperties = [];
        userData.forEach((key, value) {
          if (value == null) {
            nullProperties.add(key);
          }
        });

        // Check if any value in the userData map is null
        if (nullProperties.isNotEmpty) {
          print(
              'Properties ${nullProperties.toString()} have null values. Not uploading.');
          return; // Exit the method without uploading
        }

        await _firestore.collection('users').doc(userId).set(userData);
        print('User data uploaded successfully');
        print('Map: $userData');
      } else {
        print('No user signed in.');
      }
    } catch (e) {
      print('Error uploading user data: $e');
      // Handle error accordingly
    }
  }

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      print('Current user: $user');
      if (user != null) {
        String userId = user.uid;

        // Get null properties
        List<String> nullProperties = [];
        userData.forEach((key, value) {
          if (value == null) {
            nullProperties.add(key);
          }
        });

        // Check if any value in the userData map is null
        if (nullProperties.isNotEmpty) {
          print(
              'Properties ${nullProperties.toString()} have null values. Not updating.');
          return; // Exit the method without updating
        }

        await _firestore.collection('users').doc(userId).update(userData);
        print('User data updated successfully');
        print('Map: $userData');
      } else {
        print('No user signed in.');
      }
    } catch (e) {
      print('Error updating user data: $e');
      // Handle error accordingly
    }
  }

  Future<Map<String, dynamic>?> loadUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      print('Current user: $user');
      if (user != null) {
        String userId = user.uid;
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('users').doc(userId).get();
        if (snapshot.exists) {
          return snapshot.data();
        } else {
          print('User profile not found for user with ID: $userId');
          return null;
        }
      } else {
        print('No user signed in.');
        return null;
      }
    } catch (e) {
      print('Error loading user profile: $e');
      return null;
    }
  }
}
