import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SwipeService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference swipesCollection =
      FirebaseFirestore.instance.collection('swipes');

  // Method to upload swipe data to Firestore
  Future<void> uploadSwipeData(Swipe swipe, String userId) async {
    try {
      // Check if a swipe with the same swipedUserId already exists in the swipes collection
      QuerySnapshot swipeQuery = await swipesCollection
          .where('swipedUserId', isEqualTo: swipe.swipedUserId)
          .get();

      if (swipeQuery.docs.isNotEmpty) {
        // If a swipe with the same swipedUserId exists, delete the existing document
        await swipesCollection.doc(swipeQuery.docs.first.id).delete();
      }

      // Add the new swipe document to the swipes collection
      await swipesCollection.add(swipe.toMap());

      // Get the existing swipes list from the user document
      DocumentSnapshot userDoc = await usersCollection.doc(userId).get();
      List<dynamic> existingSwipes = userDoc.get('swipes') ?? [];

      // Check if a swipe with the same swipedUserId already exists
      int existingIndex = existingSwipes
          .indexWhere((s) => s['swipedUserId'] == swipe.swipedUserId);

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

      print('Swipe data uploaded successfully!');
    } catch (e) {
      print('Error uploading swipe data: $e');
    }
  }

  // Method to create a swipe with current user's ID
  Future<void> makeSwipe({
    required String swipedUserId,
    required String swipeType,
  }) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      Swipe swipe = Swipe(
        userId: currentUserId,
        swipedUserId: swipedUserId,
        swipeType: swipeType,
        timestamp: Timestamp.now(),
      );
      await uploadSwipeData(swipe, currentUserId);
      print('Swipe made successfully!');
    } catch (e) {
      print('Error making swipe: $e');
    }
  }

  // Method to count identical properties in two maps
  int countIdenticalProperties(
    Map<String, dynamic> map1,
    Map<String, dynamic> map2,
  ) {
    if (map1.isEmpty || map2.isEmpty) {
      return 0; // Return 0 if either map is empty
    }

    // Create sets from the keys of the two maps
    Set<String> keys1 = map1.keys.toSet();
    Set<String> keys2 = map2.keys.toSet();

    // Find the intersection of the keys
    Set<String> commonKeys = keys1.intersection(keys2);

    int count = 0;

    // Count the identical properties
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
  final String userId;
  final String swipedUserId;
  final String swipeType;
  final Timestamp timestamp;

  Swipe({
    required this.userId,
    required this.swipedUserId,
    required this.swipeType,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'swipedUserId': swipedUserId,
      'swipeType': swipeType,
      'timestamp': timestamp,
    };
  }
}
