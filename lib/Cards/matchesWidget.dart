import 'package:badges/badges.dart' as badges;
import 'package:childfree_romance/Cards/user_card_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Notifiers/all_users_notifier.dart';
import '../Screens/chat_widget.dart';
import 'matchCard.dart';

class MatchesWidget extends StatefulWidget {
  const MatchesWidget({Key? key}) : super(key: key);

  @override
  _MatchesWidgetState createState() => _MatchesWidgetState();
}

class _MatchesWidgetState extends State<MatchesWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _currentUser;
  String mode = 'Romance';
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
      print('Getting matches');
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
              await _firestore.collection('users').doc(userId).get();
          if (userSnapshot.exists) {
            final snapshotData = userSnapshot.data() as Map<String, dynamic>;

            matches.add({
              'matchId': match.id,
              'relationshipType': match['relationshipType'],
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
      print('Matched user data set. Matches: $_matchedUserData');
      _isLoading = false;
    });
  }

  Future<void> unmatch(String matchId) async {
    try {
      // Delete the match document from Firestore
      await _firestore.collection('matches').doc(matchId).delete();
      print('Match with ID $matchId has been removed.');
      await _fetchMatches();
      setState(() {});
      // Refresh data after unmatching
    } catch (e) {
      print('Error removing match: $e');
    }
  }

  void _showProfilePopup(String matchId, Map<String, dynamic> userData,
      BuildContext providerContext) {
    String uid = _auth.currentUser!.uid;
    String profilePictureUrl = _auth.currentUser!.photoURL ?? '';
    AllUsersNotifier _allUsersNotifier =
        Provider.of<AllUsersNotifier>(providerContext, listen: false);

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
                                  name: userData['name'],
                                  profilePictureUrl:
                                      userData['profilePictures'] != null &&
                                              userData['profilePictures']
                                                  .isNotEmpty
                                          ? userData['profilePictures'][0]
                                          : '',
                                  notifier: _allUsersNotifier),
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Unmatch"),
                                content: Column(
                                  children: [
                                    Text(
                                        "Are you sure you want to unmatch this user?"),
                                    Text("Refresh your page to see results.")
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      unmatch(matchId); // Call unmatch method
                                    },
                                    child: Text("Unmatch"),
                                  ),
                                ],
                              );
                            },
                          );
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
    List<Map<String, dynamic>> romanceMatches = [];
    List<Map<String, dynamic>> friendshipMatches = [];

    // Separate matchedUserData based on relationshipType
    for (var userData in _matchedUserData) {
      if (userData['relationshipType'] == 'Romance') {
        romanceMatches.add(userData);
      } else if (userData['relationshipType'] == 'Friendship') {
        friendshipMatches.add(userData);
      }
    }

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _currentUser == null
            ? Center(
                child: Text('No user logged in.'),
              )
            : (romanceMatches.isEmpty && friendshipMatches.isEmpty)
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
                      children: [
                        if (romanceMatches.isNotEmpty)
                          Column(
                            children: [
                              Text(
                                'Romance Matches',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 10),
                              Column(
                                children: romanceMatches.map((userData) {
                                  return _buildMatchCard(userData);
                                }).toList(),
                              ),
                            ],
                          ),
                        if (friendshipMatches.isNotEmpty)
                          Column(
                            children: [
                              Text(
                                'Friendship Matches',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 10),
                              Column(
                                children: friendshipMatches.map((userData) {
                                  return _buildMatchCard(userData);
                                }).toList(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
  }

  Widget _buildMatchCard(Map<String, dynamic> userData) {
    String matchId = userData['matchId'];
    Map<String, dynamic> user = userData['userData'];
    String? profilePicture;
    if (user.containsKey('profilePictures') &&
        user['profilePictures'] != null &&
        user['profilePictures'].length > 0 &&
        user['profilePictures'][0] != null &&
        user['profilePictures'][0].isNotEmpty) {
      profilePicture = user['profilePictures'][0] ?? 'placeholder';
    } else {
      profilePicture = 'placeholder';
    }
    List<dynamic> messages = userData['messages'] ?? [];
    String userThatSentMessage = '';
    String lastMessage = 'Start a conversation'; // Default message
    int messageCount = 0;

    if (messages.isNotEmpty) {
      String uid = messages.last['userId'];
      if (uid == _currentUser!.uid) {
        userThatSentMessage = messages.last['userId'];
        lastMessage = 'You: ' + messages.last['text'];
      } else {
        lastMessage = messages.last['text'] ??
            'Start a conversation'
                '';
      }

      // Calculate the message count since the last user message
      for (int i = messages.length - 1; i >= 0; i--) {
        if (messages[i]['userId'] != _currentUser!.uid) {
          messageCount++;
        } else {
          break; // Stop counting messages when the last user message is found
        }
      }
    }

    String name = user['name'];
    return GestureDetector(
      onTap: () {
        _showProfilePopup(matchId, user, context);
      },
      child: messageCount > 0
          ? badges.Badge(
              position: badges.BadgePosition.topStart(start: 0, top: 0),
              badgeContent: Text(
                messageCount.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: MatchCard(
                imageUrl: profilePicture!,
                name: name,
                lastMessage: lastMessage!, // Placeholder
              ),
            )
          : MatchCard(
              imageUrl: profilePicture!,
              name: name,
              lastMessage: lastMessage!, // Placeholder
            ),
    );
  }
}
