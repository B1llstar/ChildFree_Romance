import 'package:cloud_firestore/cloud_firestore.dart';

import '../Notifiers/all_users_notifier.dart';

class MatchmakingService {
  final String uid;
  final AllUsersNotifier allUsersNotifier;
  List<Map<String, dynamic>> initialPool = [];
  List<Map<String, dynamic>>? _filteredPool;
  List<Map<String, dynamic>> _matches = [];
  // Getter for matches
  List<Map<String, dynamic>> get matches => _matches;
  List<Map<String, dynamic>> _friendshipMatches = [];
  Map<String, dynamic>? _currentUser;
  MatchmakingService(this.uid, this.allUsersNotifier) {
    init();
  }

  Future<List<Map<String, dynamic>>> getListsBasedOnDesired(
      Map<String, dynamic> user, List<Map<String, dynamic>> pool) async {
    List<Map<String, dynamic>> matches = [];
    if (user['isLookingFor'] == 'Romance') {
      matches
          .addAll(await getDesiredMatches(user, pool, 'desiredGenderRomance'));
    } else if (user['isLookingFor'] == 'Friendship') {
      matches.addAll(
          await getDesiredMatches(user, pool, 'desiredGenderFriendship'));
    } else {
      List<Map<String, dynamic>> matchesRomance =
          await getDesiredMatches(user, pool, 'desiredGenderRomance');
      List<Map<String, dynamic>> matchesFriendship =
          await getDesiredMatches(user, pool, 'desiredGenderFriendship');
      matches.addAll(matchesRomance);
      matches.addAll(matchesFriendship);
    }

    // Remove duplicates by converting the list to a set and back to a list
    matches = matches.toSet().toList();

    return matches;
  }

  Future<void> init() async {
    // Define an initial pool using the notifier
    initialPool = allUsersNotifier.profiles;
    _currentUser = allUsersNotifier.currentUser;

    _matches = await getListsBasedOnDesired(_currentUser!, initialPool);
    print('Matches: $_matches');

    // Define a filtered pool by removing swiped items
    //List<Map<String, dynamic>> afterRemovingSwipedItems =
    //await removeSwipedItems(uid, initialPool);
    // Remove non-compatibles
    // Sort by amount of property matches
//    _filteredPool = await sortListBySimilarity(initialPool);
  }

  Future<List<Map<String, dynamic>>> getDesiredMatches(
      Map<String, dynamic> userPreferences,
      List<Map<String, dynamic>> userList,
      String property) async {
    // Store properties from the userPreferences map
    String isLookingFor = userPreferences['isLookingFor'];
    String desiredGenderRomance = userPreferences[property];
    String gender = userPreferences['gender'];

    List<Map<String, dynamic>> romanceMatches = [];

    // Iterate through the userList
    for (var user in userList) {
      // Check if the gender of the user matches the desiredGenderRomance
      if (user['gender'] == desiredGenderRomance) {
        // Check if the desiredGenderRomance of the user matches the gender of the userPreferences
        if (user['desiredGenderRomance'] == gender ||
            user['desiredGenderRomance'] == 'Both') {
          romanceMatches.add(user);
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
