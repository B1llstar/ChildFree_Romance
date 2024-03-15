// TODO: If the user has no age, ask them for it

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Utils/debug_utils.dart';
import '../settings.dart' as settings;

class SettingsService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('test_users');

  SettingsService();

  Future<void> init() async {
    int isLookingForFriendshipCount = 0;
    int isLookingForRomanceCount = 0;
    int femaleCount = 0;
    int maleCount = 0;
    int malesLookingForFriendship = 0;
    int femalesLookingForFriendship = 0;
    int malesLookingForRomance = 0;
    int femalesLookingForRomance = 0;

    try {
      print('Ranking users...');
      final rankedUsers = await rankUsers();
      print(rankedUsers);
      final filteredRankedUsers = rankedUsers
          .where((userRank) => userRank.userSettings.age != 0)
          .toList(); // Filter out users with age equal to zero
      filteredRankedUsers.forEach((element) {
        print(
            'Age: ${element.userSettings.age.toString()}'); // Print the age of each user
        print('Gender: ${element.userSettings.gender}');

        if (element.userSettings.isLookingFor == 'Friendship') {
          isLookingForFriendshipCount++;
          if (element.userSettings.gender == 'Male') {
            malesLookingForFriendship++;
          } else {
            femalesLookingForFriendship++;
          }
        } else if (element.userSettings.isLookingFor == 'Romance') {
          if (element.userSettings.gender == 'Male') {
            malesLookingForRomance++;
          } else {
            femalesLookingForRomance++;
          }
          isLookingForRomanceCount++;
        } else {
          if (element.userSettings.gender == 'Male') {
            malesLookingForFriendship++;
          } else {
            femalesLookingForFriendship++;
          }
          isLookingForFriendshipCount++;
          isLookingForRomanceCount++;
        }

        if (element.userSettings.gender == 'Female') {
          femaleCount++;
        } else {
          maleCount++;
        }
      });
      DebugUtils.printDebug(
          'Amount of ranked users:${filteredRankedUsers.length}');

      print('People looking for friendship: $isLookingForFriendshipCount');
      print('People looking for romance: $isLookingForRomanceCount');
      print('Female count: $femaleCount');
      print('Male count: $maleCount');
      print('Males looking for romance:  $malesLookingForRomance');
      print('Females looking for romance: $femalesLookingForRomance');
      print('Males looking for friendship: $malesLookingForFriendship');
      print('Females looking for friendship: $femalesLookingForFriendship');
      // Process ranked users or perform any additional tasks
    } catch (e) {
      print('Error initializing SettingsService: $e');
      // Handle error
    }
  }

  Future<List<UserRank>> rankUsers() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No current user');
    }

    final currentUserSnapshot =
        await _userCollection.doc(currentUser.uid).get();
    settings.Settings currentUserSettings = settings.Settings.fromMap(
        currentUserSnapshot.data() as Map<String, dynamic>);

    final List<UserRank> rankedUsers = [];

    // Fetch all users except the current user
    final QuerySnapshot userSnapshots = await _userCollection.get();
    for (final userSnapshot in userSnapshots.docs) {
      if (userSnapshot.id != currentUser.uid) {
        settings.Settings userSettings = settings.Settings.fromMap(
            userSnapshot.data() as Map<String, dynamic>);
        final int identicalPairs =
            currentUserSettings.compareSettings(userSettings);

        rankedUsers.add(UserRank(
            userSettings: userSettings, identicalPairs: identicalPairs));
      }
    }

    // Sort the users based on the number of identical pairs (most similar first)
    rankedUsers.sort((a, b) => b.identicalPairs.compareTo(a.identicalPairs));

    return rankedUsers;
  }
}

class UserRank {
  final settings.Settings userSettings;
  final int identicalPairs;

  UserRank({required this.userSettings, required this.identicalPairs});
}
