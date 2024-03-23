import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class SwipeService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference swipesCollection =
      FirebaseFirestore.instance.collection('swipes');
  Future<void> printNumberOfSwipes() async {
    try {
      QuerySnapshot querySnapshot = await swipesCollection.get();
      int numberOfSwipes = querySnapshot.size;
      print('Number of documents in swipes collection: $numberOfSwipes');
    } catch (e) {
      print('Error printing number of swipes: $e');
    }
  }

  Future<void> uploadSwipeData(
      Swipe swipe, String userId, bool isRomance) async {
    try {
      printNumberOfSwipes();
      // Check if a swipe with the same swipedUserId already exists
      final existingSwipeQuery = await swipesCollection
          .where('userId', isEqualTo: swipe.userId)
          .where('swipedUserId', isEqualTo: swipe.swipedUserId)
          .get();
      print('User Ids: ${swipe.userIds}');
      if (existingSwipeQuery.docs.isNotEmpty) {
        // Delete the existing swipe document

        // Delete all
        existingSwipeQuery.docs.forEach((doc) async {
          await swipesCollection.doc(doc.id).delete();
        });
        print('Deleted ' +
            existingSwipeQuery.docs.length.toString() +
            " documents");
      }

      // Check for match before uploading the swipe
      await swipesCollection.doc(swipe.swipeId).set(swipe.toMap());
      final userSwipeId = swipe.swipeId;
      await checkForMatch(
          swipe.swipedUserId, swipe.swipeType, userSwipeId, isRomance);

      // Generate a unique swipeId

      // Add the new swipe document to the swipes collection with swipeId

      // Get the existing swipes list from the user document
      /*
      DocumentSnapshot userDoc = await usersCollection.doc(userId).get();

      List<dynamic> existingSwipes = userDoc.get('swipes') ?? [];

      // Check if a swipe with the same swipeId already exists
      int existingIndex =
          existingSwipes.indexWhere((s) => s['swipeId'] == swipe.swipeId);

      if (existingIndex != -1) {
        // Remove the existing swipe from the list
        existingSwipes.removeAt(existingIndex);
      }

      // Add the new swipe to the existing list
      existingSwipes.add(swipe.toMap());

      // Update 'swipes' property in user document
      await usersCollection.doc(userId).set(
        {'swipes': existingSwipes},
        SetOptions(merge: true),
      );
*/
      print('Swipe data uploaded successfully!');
    } catch (e) {
      print('Error uploading swipe data: $e');
    }
  }

  Future<void> makeMatch(String userIdSwipedFirst, bool isRomance) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      // Check if the current user ID is equal to both userIdSwipedFirst and currentUserId
      if (userIdSwipedFirst == currentUserId) {
        print(
            'Error creating match: Current user cannot match with themselves.');
        return;
      }

      String matchId = Uuid().v4();
      List<String> userIds = [userIdSwipedFirst, currentUserId];
      userIds.sort(); // Sort the user IDs alphabetically
      Map<String, dynamic> matchData = {
        'matchId': matchId,
        'userIdSwipedFirst': userIdSwipedFirst,
        'userIdSwipedSecond': currentUserId,
        'userIds': userIds,
        'relationshipType': isRomance ? 'Romance' : 'Friendship',
        'messages': [],
      };

      // Upload the match data to 'matches' collection
      await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .set(matchData);
      print('Match created successfully!');
    } catch (e) {
      print('Error creating match: $e');
    }
  }

  // Check to see whether the other user (the person the current user just swiped) swiped them back already
  Future<void> checkForMatch(String swipedUserId, String swipeType,
      String userSwipeId, bool isRomance) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Check if there is a match already
      QuerySnapshot querySnapshot = await swipesCollection
          .where('swipeType', isEqualTo: swipeType)
          .where('userId', isEqualTo: swipedUserId)
          .where('swipedUserId', isEqualTo: currentUserId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If there is a match, delete the existing swipe document
        // This prevents duplicate matches from being made later
        await swipesCollection.doc(querySnapshot.docs.first.id).delete();
        await swipesCollection.doc(userSwipeId).delete();
        print('Existing match swipes found and deleted.');

        // Extract userIdSwipedFirst from the deleted document
        String userIdSwipedFirst = querySnapshot.docs.first['userId'];

        // Create a match with userIdSwipedFirst and the current user
        await makeMatch(userIdSwipedFirst, isRomance);
      }
    } catch (e) {
      print('Error checking for match: $e');
    }
  }

  Future<void> makeRandomSwipe(String swipeType, bool isRomance) async {
    try {
      // Get a random document from the 'users' collection
      QuerySnapshot querySnapshot = await usersCollection.get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      int randomIndex = Random().nextInt(documents.length);
      String swipedUserId = documents[randomIndex].id;

      // Make a swipe with the random user's userId
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      String swipeId = Uuid().v4();
      List<String> userIds = [currentUserId, swipedUserId];
      userIds.sort(); // Sort the user IDs alphabetically
      Swipe swipe = Swipe(
        swipeId: swipeId,
        userId: swipedUserId,
        swipedUserId: currentUserId,
        swipeType: swipeType,
        userIds: userIds,
        relationshipType: isRomance ? 'Romance' : 'Friendship',
        timestamp: Timestamp.now(),
      );
      await uploadSwipeData(swipe, currentUserId, isRomance);
      print('Random swipe made successfully!');
    } catch (e) {
      print('Error making random swipe: $e');
    }
  }

  Future<void> makeSwipe(
      {required String swipedUserId,
      required String swipeType,
      required bool isRomance}) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      String swipeId = Uuid().v4();
      List<String> userIds = [currentUserId, swipedUserId];
      userIds.sort(); // Sort the user IDs alphabetically
      Swipe swipe = Swipe(
        swipeId: swipeId,
        userId: currentUserId,
        swipedUserId: swipedUserId,
        swipeType: swipeType,
        userIds: userIds,
        relationshipType: isRomance ? 'Romance' : 'Friendship',
        timestamp: Timestamp.now(),
      );
      await uploadSwipeData(swipe, currentUserId, isRomance);
      print('Swipe made successfully!');
    } catch (e) {
      print('Error making swipe: $e');
    }
  }

  int countIdenticalProperties(
    Map<String, dynamic> map1,
    Map<String, dynamic> map2,
  ) {
    if (map1.isEmpty || map2.isEmpty) {
      return 0; // Return 0 if either map is empty
    }

    Set<String> keys1 = map1.keys.toSet();
    Set<String> keys2 = map2.keys.toSet();

    Set<String> commonKeys = keys1.intersection(keys2);

    int count = 0;

    for (String key in commonKeys) {
      dynamic value1 = map1[key];
      dynamic value2 = map2[key];

      if (value1 == value2) {
        count++;
      }
    }

    return count;
  }
}

class Swipe {
  final String swipeId;
  final String userId;
  final String swipedUserId;
  final String swipeType;
  final List<String> userIds;
  final Timestamp timestamp;
  final String relationshipType;
  Swipe({
    required this.swipeId,
    required this.userId,
    required this.swipedUserId,
    required this.swipeType,
    required this.userIds,
    required this.timestamp,
    required this.relationshipType,
  });

  Map<String, dynamic> toMap() {
    return {
      'swipeId': swipeId,
      'userId': userId,
      'swipedUserId': swipedUserId,
      'swipeType': swipeType,
      'userIds': userIds,
      'timestamp': timestamp,
      'relationshipType': relationshipType,
    };
  }
}
