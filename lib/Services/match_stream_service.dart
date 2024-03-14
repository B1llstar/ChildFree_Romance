import 'package:childfree_romance/Services/swipe_service.dart';
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
    _swipesStream = FirebaseFirestore.instance.collection('swipes').snapshots();
    _swipesStream!.listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {}
    });
  }

  init() async {
    await SwipeService().makeRandomSwipe('standardYes');
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
}
