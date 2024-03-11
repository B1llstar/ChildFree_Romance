import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Notifiers/all_users_notifier.dart';

class MatchmakingNotifier extends ChangeNotifier {
  final String uid;
  final AllUsersNotifier allUsersNotifier;

  // Starting Pool
  List<Map<String, dynamic>> initialPool = [];

  List<Map<String, dynamic>>? _filteredPool;

  List<Map<String, dynamic>> _previousSwipes = [];

  List<Map<String, dynamic>> get previousSwipes => _previousSwipes;

  // Total List
  List<Map<String, dynamic>> _allMatches = [];
  List<Map<String, dynamic>> get allMatches => _allMatches;

  // Friendship List
  List<Map<String, dynamic>> _friendshipMatches = [];

  // Romance List
  List<Map<String, dynamic>> _romanceMatches = [];

  Map<String, dynamic>? _currentUser;

  // The all users notifier is responsible for grabbing the user and the pool of everyone
  MatchmakingNotifier(this.uid, this.allUsersNotifier) {
    init();
  }

  Future<List<Map<String, dynamic>>> getRomanceAndFriendshipMatches(
      Map<String, dynamic> user, List<Map<String, dynamic>> pool) async {
    List<Map<String, dynamic>> matches = [];

    // If they want Romance,
    if (user['isLookingFor'] == 'Romance') {
      print('Looking for Romance');
      _romanceMatches =
          await getDesiredMatches(user, pool, 'desiredGenderRomance');

      matches.addAll(_romanceMatches);
    } else if (user['isLookingFor'] == 'Friendship') {
      print('Looking for Friendship');
      _friendshipMatches =
          await getDesiredMatches(user, pool, 'desiredGenderFriendship');
      print('Friendship matches: $_friendshipMatches');
      matches.addAll(_friendshipMatches);
    } else {
      _romanceMatches =
          await getDesiredMatches(user, pool, 'desiredGenderRomance');
      print('Romance matches: $_romanceMatches');
      _friendshipMatches =
          await getDesiredMatches(user, pool, 'desiredGenderFriendship');
      print('Friendship matches: $_friendshipMatches');
      matches.addAll(_romanceMatches);
      matches.addAll(_friendshipMatches);
    }

    // Remove duplicates by converting the list to a set and back to a list

    // Remove Duplicates
    matches = removeDuplicates(matches);
    _romanceMatches = removeDuplicates(_romanceMatches);
    _friendshipMatches = removeDuplicates(_friendshipMatches);

    return matches;
  }

  List<Map<String, dynamic>> removeDuplicates(
      List<Map<String, dynamic>> matches) {
    return matches.toSet().toList();
  }

  Future<void> init() async {
    // Define an initial pool using the notifier
    print('Initial pool: ${allUsersNotifier.profiles}');
    initialPool = allUsersNotifier.profiles;
    _currentUser = allUsersNotifier.currentUser;

    _allMatches =
        await getRomanceAndFriendshipMatches(_currentUser!, initialPool);
    print('Matches: $_allMatches');

    // Define a filtered pool by removing swiped items
    //List<Map<String, dynamic>> afterRemovingSwipedItems =
    //await removeSwipedItems(uid, initialPool);
    // Remove non-compatibles
    // Sort by amount of property matches
//    _filteredPool = await sortListBySimilarity(initialPool);
  }

  void removeItemFromEveryMatchlist(Map<String, dynamic> item) {
    _allMatches.remove(item);
    _friendshipMatches.remove(item);
    _romanceMatches.remove(item);
    notifyListeners();
  }

  void addToPreviousSwipesList(Map<String, dynamic> item) {
    if (!_previousSwipes.contains(item)) _previousSwipes.add(item);
    print('Previous swipes: $_previousSwipes');
    print('Length: ${_previousSwipes.length}');
  }

  Future<List<Map<String, dynamic>>> getDesiredMatches(
      Map<String, dynamic> userPreferences,
      List<Map<String, dynamic>> userList,
      String property) async {
    // Store properties from the userPreferences map
    String desiredGenderRomance = userPreferences[property];
    String gender = userPreferences['gender'];
    print('User desired gender: $desiredGenderRomance');

    List<Map<String, dynamic>> romanceMatches = [];

    // Iterate through the userList
    for (var user in userList) {
      print('Iterating... checking user: ${user['name']}');
      print('Item gender: ${user['gender']}');

      // Check if the gender of the user matches the desiredGenderRomance
      if (user['gender'] == desiredGenderRomance ||
          desiredGenderRomance == 'Any') {
        print('Foudn a potential match');
        // Check if the desiredGenderRomance of the user matches the gender of the userPreferences
        if (user[property] == gender || user[property] == 'Any') {
          romanceMatches.add(user);
          print('Adding user: ${user['name']}');
        }
      }
    }

    return romanceMatches;
  }

  Future<List<Map<String, dynamic>>> getFilteredPool() async {
    if (_filteredPool == null) {
      // If filteredPool is not initialized, call init() first
      // Good practice
      await init();
    }
    return Future.value(_filteredPool); // Return the Future value
  }

  Future<List<Map<String, dynamic>>> getSwipedItems(String uid) async {
    List<Map<String, dynamic>> swipedItems = [];

    // Access Firestore to retrieve user data
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      List<dynamic> swipes = userData['swipes'];

      // Iterate through the swipes
      for (var swipe in swipes) {
        // Get the swiped user ID
        String swipedUserId = swipe['swipedUserId'];

        // Add swiped item to the list
        swipedItems.add({
          'userId': swipedUserId,
          // Add any other relevant data you need
        });
      }
    }

    return swipedItems;
  }

  Future<List<Map<String, dynamic>>> removeSwipedItems(
      String uid, List<Map<String, dynamic>> items) async {
    List<Map<String, dynamic>> filteredItems = [];

    // Access Firestore to retrieve user data
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      List<dynamic> swipes = userData['swipes'];

      // Iterate through the items
      for (var item in items) {
        bool isSwiped = false;

        // Compare with swipedUserId
        for (var swipe in swipes) {
          if (swipe['swipedUserId'] == item['userId']) {
            isSwiped = true;
            break;
          }
        }

        // If not swiped, add to filteredItems
        if (!isSwiped) {
          filteredItems.add(item);
        }
      }
    }

    return filteredItems;
  }

  List<Map<String, dynamic>> filterListBasedOnProperty(
      List<Map<String, dynamic>> list, String property, dynamic value) {
    List<Map<String, dynamic>> filteredList = [];

    for (var item in list) {
      if (item.containsKey(property) && item[property] == value) {
        filteredList.add(item);
      }
    }

    return filteredList;
  }

  Future<List<Map<String, dynamic>>> sortListBySimilarity(
      List<Map<String, dynamic>> list) async {
    // Get the user's preferences
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!userSnapshot.exists) {
      return list;
    }

    Map<String, dynamic> userPreferences =
        userSnapshot.data() as Map<String, dynamic>;

    list.sort((a, b) {
      // Count identical properties for each pair of maps
      int identicalA = countIdenticalProperties(a, userPreferences);
      int identicalB = countIdenticalProperties(b, userPreferences);
      // Sort in descending order
      return identicalB.compareTo(identicalA);
    });

    return list;
  }

  int countIdenticalProperties(
      Map<String, dynamic> map1, Map<String, dynamic> map2) {
    int count = 0;

    for (var key in map1.keys) {
      if (map2.containsKey(key)) {
        if (map1[key] == map2[key]) {
          count++;
        }
      }
    }

    return count;
  }
}
