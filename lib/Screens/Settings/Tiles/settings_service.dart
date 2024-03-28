import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../distance_calculator.dart';

class MatchService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> get allUsers => _allUsers;
  List<Map<String, dynamic>> _romanceMatches = [];
  List<Map<String, dynamic>> get romanceMatches => _romanceMatches;
  List<Map<String, dynamic>> _friendshipMatches = [];
  List<Map<String, dynamic>> get friendshipMatches => _friendshipMatches;
  List<Map<String, dynamic>> _friendshipAndRomanceMatches = [];
  List<Map<String, dynamic>> _matches = [];
  bool _initialized = false;
  bool get initialized => _initialized;
  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> get matches => _matches;
  int _totalNopeSwipes = 0;
  int get totalNopeSwipes => _totalNopeSwipes;
  int _totalStandardYesSwipes = 0;
  int get totalStandardYesSwipes => _totalStandardYesSwipes;
  String _glowType = 'None';
  String get glowType => _glowType;
  set glowType(String value) {
    _glowType = value;
    print('Changing glow type...');
    notifyListeners();
  }

  List<Map<String, dynamic>> get friendshipAndRomanceMatches =>
      _friendshipAndRomanceMatches;
  List<String> _profilePictures = [];
  List<String> get profilePictures => _profilePictures;

  MatchService() {
    init();
    subscribeToMatchesStream();
  }
  void subscribeToMatchesStream() {
    final user = _auth.currentUser;
    if (user != null) {
      final userMatchesRef = _firestore
          .collection('matches')
          .where('userIds', arrayContains: user.uid);
      userMatchesRef.snapshots().listen((snapshot) {
        final updatedMatches = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        updateMatches(updatedMatches);
      });
    }
  }

  void updateMatches(List<Map<String, dynamic>> updatedMatches) {
    _matches = updatedMatches;
    notifyListeners();
  }

  refreshAllNopeSwipesForRelationshipType(String relationshipType) async {
    final swipesCollectionRef = _firestore.collection('swipes');
    // Grab all documents where userId is equal to the current user and the swipeType is equal to 'nope'
    await swipesCollectionRef
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .where('relationshipType', isEqualTo: relationshipType)
        .where('swipeType', isEqualTo: 'nope')
        .get()
        .then((querySnapshot) {
      // Loop through each document
      querySnapshot.docs.forEach((doc) {
        print('Found a document');
        // Delete the document
        doc.reference.delete();
      });
    });
    notifyListeners();
  }

  Future<void> init() async {
    await fetchAndStoreUserData();
    await fetchAndStoreAllUsers();
    await Future.delayed(
        Duration.zero); // Wait for other async operations to complete
    await removeSwipedUsers();
    await generateRomanceMatches();
    await generateFriendshipMatches();
    initialized = true;
    notifyListeners();
    // Call removeSwipedUsers after other async operations
  }

  removeAllWhereVisibleIsFalse() async {
    _romanceMatches.removeWhere((match) => match['visible'] == false);
    _friendshipMatches.removeWhere((match) => match['visible'] == false);
  }

  Future<List<String>> getProfilePictures(BuildContext context) async {
    // Extract profile pictures from the _allUsers list
    List<String> profilePictures = _friendshipAndRomanceMatches
        .where((user) =>
            user['profilePictures'] != null &&
            user['profilePictures'].isNotEmpty &&
            user['profilePictures'][0] != null &&
            user['profilePictures'][0].toString().isNotEmpty)
        .map((user) => user['profilePictures'][0].toString())
        .toList();
    // Remove duplicates
    profilePictures = profilePictures.toSet().toList();

    await Future.wait(profilePictures
        .map((urlImage) =>
            precacheImage(CachedNetworkImageProvider(urlImage), context))
        .toList());
    print('Profile pictures: ${profilePictures.length}');
    return profilePictures;
  }

  Future<void> fetchAndStoreUserData() async {
    try {
      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Get the user document from Firestore
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

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
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      // Extract user data from the documents
      _allUsers = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      // Remove where visibility is false
      _allUsers.removeWhere((user) => user['visible'] == false);
      _allUsers.removeWhere((user) =>
          user['profilePictures'] == null ||
          user['profilePictures'] != null && user['profilePictures'].isEmpty);

      double? currentUserLatitude = _userData?['locale']['latitude'];
      double? currentUserLongitude = _userData?['locale']['longitude'];
      if (currentUserLatitude == null || currentUserLongitude == null) {
        return;
      }
      // Calculate and assign distance for each user
      _allUsers.forEach((user) {
        // Check if user has 'locale' property and it contains 'latitude' and 'longitude'
        if (user.containsKey('locale') &&
            user['locale'] is Map<String, dynamic> &&
            user['locale'].containsKey('latitude') &&
            user['locale'].containsKey('longitude')) {
          double userLatitude = user['locale']['latitude'];
          double userLongitude = user['locale']['longitude'];
          double distance = DistanceCalculator.calculateDistance(
            currentUserLatitude!,
            currentUserLongitude!,
            userLatitude,
            userLongitude,
          );
          user['distance'] = distance.toStringAsFixed(2);
          print(
              'Distance to user ${user['userId']}: ${user['distance']} miles');
        } else {
          // Indicate if latitude or longitude is missing
          print(
              'Unable to calculate distance to user ${user['userId']}: Latitude or longitude missing');
        }
      });
    } catch (e) {
      print('Error fetching and storing all users: $e');
    }
  }

  List<Map<String, dynamic>> filterUsersWithinDistance(
      List<Map<String, dynamic>> users, double maxDistance) {
    return users
        .where((user) =>
            user.containsKey('distance') &&
            double.parse(user['distance']) <= maxDistance)
        .toList();
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
      friendshipAndRomanceMatches.addAll(_romanceMatches);
      // Randomize all elements
      friendshipAndRomanceMatches.shuffle();
      _romanceMatches.shuffle();

      notifyListeners();
    } catch (e) {
      print('Error generating romance matches: $e');
    }
  }

  Future<void> removeSwipedUsers() async {
    try {
      print('Removing Swiped Users');
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch swipes from Firestore
      QuerySnapshot swipeSnapshot =
          await FirebaseFirestore.instance.collection('swipes').get();

      // Iterate through swipes
      swipeSnapshot.docs.forEach((doc) {
        Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;

        if (docData != null) {
          String? swipedUserId = docData['swipedUserId'];
          String? swipeType = docData['swipeType'];
          String userId = docData['userId'];
          String uid = FirebaseAuth.instance.currentUser!.uid;
          String? relationshipType = docData['relationshipType'];

          if (swipedUserId != null && uid == userId) {
            if (swipeType == 'standardYes') {
              _totalStandardYesSwipes++;
              print('Total Yes Swipes: $_totalStandardYesSwipes');
            }
            if (swipeType == 'nope') {
              _totalNopeSwipes++;
              print('Total Nope Swipes: $_totalNopeSwipes');
            }
            print('Found a yes document');
            print('Swiped user id: $swipedUserId');
            // Remove swiped user based on relationship type
            if (relationshipType == 'Romance') {
              _allUsers.removeWhere((user) => user['userId'] == swipedUserId);
            } else if (relationshipType == 'Friendship') {
              _allUsers.removeWhere((user) => user['userId'] == swipedUserId);
            }
            // Remove swiped user from friendshipAndRomanceMatches
            _allUsers.removeWhere((user) => user['userId'] == swipedUserId);
          }
        }
      });

      print('Swiped users removed');
      notifyListeners();
    } catch (e) {
      print('Error removing swiped users: $e');
    }
  }

  Future<void> generateFriendshipMatches() async {
    try {
      // First, it checks to see if their gender matches the current user's desired gender OR the user wants anything
      // Then, it checks the opposite
      // Finally, it checks that they're looking for friends
      // Any and Both are used because spaghetti code

      _friendshipMatches = _allUsers
          .where((user) =>
              (user['gender'] == _userData!['desiredGenderFriendship'] ||
                      ['Any', 'Both']
                          .contains(_userData?['desiredGenderFriendship'])) &&
                  user['desiredGenderFriendship'] == _userData?['gender'] ||
              ['Any', 'Both'].contains(user?['desiredGenderFriendship']) &&
                  ['Friendship', 'Any', 'Both'].contains(user['isLookingFor']))
          .toList();

      print('Friendship Matches: $_friendshipMatches');
      print('Friendship length: ${_friendshipMatches.length}');
      friendshipAndRomanceMatches.addAll(_friendshipMatches);
      friendshipAndRomanceMatches.shuffle();
      _friendshipMatches.shuffle();
      notifyListeners();
    } catch (e) {
      print('Error generating friendship matches: $e');
    }
  }

  Future<void> refresh() async {
    try {
      await fetchAndStoreUserData();
      await fetchAndStoreAllUsers();
      await removeSwipedUsers();

      await generateRomanceMatches();
      await generateFriendshipMatches();
      print('Refresh completed');
    } catch (e) {
      print('Error refreshing data: $e');
    }
  }
}
