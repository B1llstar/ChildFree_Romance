import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SwipeStreamService extends ChangeNotifier {
  Stream<QuerySnapshot>? _swipesStream;
  List<Map<String, dynamic>> userSwipes = [];
  List<Map<String, dynamic>> swipedTheUser = [];
  String uid = '';

  SwipeStreamService() {
    uid = FirebaseAuth.instance.currentUser!.uid;
    init();
  }

  void startMonitoringSwipes() {
    print('Monitoring...');
    _swipesStream = FirebaseFirestore.instance.collection('swipes').snapshots();
    _swipesStream!.listen((snapshot) {
      for (final change in snapshot.docChanges) {
        final data = change.doc.data() as Map<String, dynamic>;
        if (change.type == DocumentChangeType.added) {
          if (data['userId'] == uid) {
            userSwipes.add(data);
            print('Added to userSwipes: $data');
            checkAndCreateMatch(
                change.doc.id, data, 'swipedUserId', 'userSwipes');
          } else if (data['swipedUserId'] == uid) {
            swipedTheUser.add(data);
            print('Added to swipedTheUser: $data');
            checkAndCreateMatch(change.doc.id, data, 'userId', 'swipedTheUser');
          }
        }
      }
    });
  }

  init() async {
    startMonitoringSwipes();
    await _getAllUserSwipes();
    await _getSwipedUser();
    lookForMatches(userSwipes, swipedTheUser);
  }

  void lookForMatches(List<Map<String, dynamic>> userSwipes,
      List<Map<String, dynamic>> swipedTheUser) {
    int count = 0;
    // Create a set to store unique user IDs from swipedTheUser list
    Set<String> swipedUserIds = Set.from(swipedTheUser.map((e) => e['userId']));
    print('Unique swiped user IDs: $swipedUserIds');

    // Iterate through userSwipes and check if userId exists in swipedUserIds set
    for (var i = 0; i < userSwipes.length; i++) {
      if (swipedUserIds.contains(userSwipes[i]['swipedUserId'])) {
        print(
            'Found a match for swiped user ID: ${userSwipes[i]['swipedUserId']}');
        count++;
      }
    }
    print('Total matches: $count');
  }

  Future<void> _getAllUserSwipes() async {
    print('Getting user swipes...');
    final querySnapshot = await FirebaseFirestore.instance
        .collection('swipes')
        .where('userId', isEqualTo: uid)
        .get();

    userSwipes = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    print('Amount of user swipes: ${userSwipes.length}');
  }

  Future<void> _getSwipedUser() async {
    print('Getting others that swiped the user...');
    final querySnapshot = await FirebaseFirestore.instance
        .collection('swipes')
        .where('swipedUserId', isEqualTo: uid)
        .get();

    swipedTheUser = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    print('Amount of swiped the user: ${swipedTheUser.length}');
  }

  Future<void> checkAndCreateMatch(String docId, Map<String, dynamic> swipeData,
      String idKey, String listType) async {
    final otherUserId = swipeData[idKey];
    final querySnapshot = await FirebaseFirestore.instance
        .collection('swipes')
        .where(idKey, isEqualTo: otherUserId)
        .where(listType, arrayContains: uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print('We found a match!');
      final matchId = FirebaseFirestore.instance.collection('matches').doc().id;
      final matchData = {
        'matchId': matchId,
        'swipes': [
          swipeData,
          ...(querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>))
        ]
      };
      await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .set(matchData);

      print('Match created with ID: $matchId');

      await FirebaseFirestore.instance.collection('swipes').doc(docId).delete();
      print('Swipe document deleted with ID: $docId');

      for (final matchSwipeDoc in querySnapshot.docs) {
        await matchSwipeDoc.reference.delete();
        print('Swipe document deleted with ID: ${matchSwipeDoc.id}');
      }

      // Remove the matched maps from the lists
      userSwipes.remove(swipeData);
      swipedTheUser.removeWhere((element) => element[idKey] == otherUserId);
    } else {
      print('Match was not found.');
    }
  }
}
