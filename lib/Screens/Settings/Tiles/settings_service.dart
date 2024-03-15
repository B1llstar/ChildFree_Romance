import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _romanceMatches = [];
  List<Map<String, dynamic>> _friendshipMatches = [];

  UserService() {
    init();
  }

  Future<void> init() async {
    await fetchAndStoreUserData();
    await fetchAndStoreAllUsers();
    await generateRomanceMatches();
    await generateFriendshipMatches();
  }

  Future<void> fetchAndStoreUserData() async {
    try {
      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Get the user document from Firestore
        DocumentSnapshot userSnapshot =
            await _firestore.collection('test_users').doc(user.uid).get();

        // Check if the document exists
        if (userSnapshot.exists) {
          // Extract user data from the document
          _userData = userSnapshot.data() as Map<String, dynamic>;

          // Store the data or do whatever you want with it
          // For example, you can store it in a local database or state management solution
          // In this example, we'll just print it
          print('User Data: $_userData');
        } else {
          // Document does not exist
          print('User document does not exist');
        }
      } else {
        // No user signed in
        print('No user signed in');
      }
    } catch (e) {
      print('Error fetching and storing user data: $e');
    }
  }

  Future<void> fetchAndStoreAllUsers() async {
    try {
      // Get all users from Firestore
      QuerySnapshot querySnapshot =
          await _firestore.collection('test_users').get();

      // Extract user data from the documents
      _allUsers = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching and storing all users: $e');
    }
  }

  Future<void> generateRomanceMatches() async {
    try {
      _romanceMatches = _allUsers
          .where((user) =>
              user['gender'] == _userData!['desiredGenderRomance'] &&
              user['desiredGenderRomance'] == _userData!['gender'] &&
              ['Romance', 'Any', 'Both'].contains(user['isLookingFor']))
          .toList();

      print('Romance Matches: $_romanceMatches');
      print('Romance length: ${_romanceMatches.length}');
    } catch (e) {
      print('Error generating romance matches: $e');
    }
  }

  Future<void> generateFriendshipMatches() async {
    try {
      _friendshipMatches = _allUsers
          .where((user) =>
              (user['gender'] == _userData!['desiredGenderFriendship'] ||
                  _userData!['desiredGenderFriendship'] == 'Any' ||
                  _userData!['desiredGenderFriendship'] == 'Both') &&
              ['Friendship', 'Any', 'Both'].contains(user['isLookingFor']))
          .toList();

      print('Friendship Matches: $_friendshipMatches');
      print('Friendship length: ${_friendshipMatches.length}');
    } catch (e) {
      print('Error generating friendship matches: $e');
    }
  }

  Future<void> refresh() async {
    try {
      await fetchAndStoreAllUsers();
      await generateRomanceMatches();
      await generateFriendshipMatches();
      print('Refresh completed');
    } catch (e) {
      print('Error refreshing data: $e');
    }
  }
}
