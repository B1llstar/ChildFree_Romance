import 'package:childfree_romance/Cards/user_card_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Notifiers/all_users_notifier.dart';
import '../Screens/chat_widget.dart';
import 'matchCard.dart';

class MatchesWidget extends StatefulWidget {
  final AllUsersNotifier allUsersNotifier;

  const MatchesWidget({Key? key, required this.allUsersNotifier})
      : super(key: key);

  @override
  _MatchesWidgetState createState() => _MatchesWidgetState();
}

class _MatchesWidgetState extends State<MatchesWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _currentUser;
  List<Map<String, dynamic>> _matchedUserData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      await _fetchMatches();
    }
  }

  Future<void> _fetchMatches() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot matchesSnapshot = await _firestore
        .collection('matches')
        .where('userIds', arrayContains: _currentUser!.uid)
        .get();

    List<Map<String, dynamic>> matches = [];
    Set<String> seenUserIds = Set(); // Set to keep track of seen user IDs

    for (QueryDocumentSnapshot match in matchesSnapshot.docs) {
      List<String> userIds = List.from(match['userIds']);
      userIds.remove(_currentUser!.uid); // Remove current user's ID
      bool isDuplicate = false;

      for (String userId in userIds) {
        if (seenUserIds.contains(userId)) {
          // Skip this match if any user ID is already seen
          isDuplicate = true;
          break;
        }
      }

      if (!isDuplicate) {
        for (String userId in userIds) {
          DocumentSnapshot userSnapshot =
              await _firestore.collection('test_users').doc(userId).get();
          if (userSnapshot.exists) {
            final snapshotData = userSnapshot.data() as Map<String, dynamic>;

            matches.add({
              'matchId': match.id,
              'userData': snapshotData,
              'messages': match['messages'] ?? []
            });

            userIds.forEach(seenUserIds.add); // Add seen user IDs to the set
          }
        }
      }
    }

    setState(() {
      _matchedUserData = matches;
      _isLoading = false;
    });
  }

  void _showProfilePopup(String matchId, Map<String, dynamic> userData) {
    String uid = _auth.currentUser!.uid;
    String profilePictureUrl = _auth.currentUser!.photoURL ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = 500;

            return SizedBox(
              height: height - 20,
              width: width - 20,
              child: Column(
                children: [
                  Expanded(
                    child: ProfileCardWeb(
                      profile: userData,
                      scrollController: ScrollController(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatWidget(
                                  matchId: matchId,
                                  uid: uid,
                                  profilePictureUrl: profilePictureUrl,
                                  notifier: widget.allUsersNotifier),
                            ),
                          );
                        },
                        child: Icon(FontAwesomeIcons.comment),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Implement unmatch functionality here
                        },
                        child: Text('Unmatch'),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _currentUser == null
            ? Center(
                child: Text('No user logged in.'),
              )
            : _matchedUserData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('You don\'t have any matches yet.'),
                        Text(
                            'Once you start swiping, your matches will show up here!'),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: _matchedUserData.map((userData) {
                        String matchId = userData['matchId'];
                        Map<String, dynamic> user = userData['userData'];
                        String? profilePicture;
                        if (user.containsKey('profilePictures') &&
                            user['profilePictures'][0] != null) {
                          profilePicture = user['profilePictures'][0];
                        } else {
                          profilePicture = 'placeholder';
                        }
                        List<dynamic> messages = userData['messages'] ?? [];
                        String userThatSentMessage = '';
                        String lastMessage = 'Start a conversation';

                        if (messages.isNotEmpty) {
                          String uid = messages.last['userId'];
                          if (uid == _currentUser!.uid) {
                            userThatSentMessage = messages.last['userId'];
                            lastMessage = 'You: ' + messages.last['text'];
                          } else {
                            lastMessage = messages.last['text'];
                          }
                        }

                        String name = user['name'];
                        return GestureDetector(
                          onTap: () {
                            _showProfilePopup(matchId, user);
                          },
                          child: MatchCard(
                            imageUrl: profilePicture!,
                            name: name,
                            lastMessage: lastMessage!, // Placeholder
                          ),
                        );
                      }).toList(),
                    ),
                  );
  }
}
