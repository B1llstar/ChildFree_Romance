import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/all_users_notifier.dart';
import 'chat_widget.dart';

class MatchesListWidget extends StatefulWidget {
  static final MatchesListWidget _singleton = MatchesListWidget._internal();

  factory MatchesListWidget() {
    return _singleton;
  }

  MatchesListWidget._internal();

  @override
  _MatchesListWidgetState createState() => _MatchesListWidgetState();
}

class _MatchesListWidgetState extends State<MatchesListWidget> {
  late String _currentUserId;
  late Map<String, Map<String, dynamic>> _userDocuments;
  late List<String> _matchIds; // Store the match IDs

  @override
  void initState() {
    super.initState();
    _userDocuments = {};
    _matchIds = []; // Initialize the match IDs list
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
      });
      await _loadMatches();
      await _loadUserDocuments();
    }
  }

  Future<void> _loadMatches() async {
    final matchesSnapshot = await FirebaseFirestore.instance
        .collection('matches')
        .where('userIds', arrayContains: _currentUserId)
        .get();
    final Set<String> allUserIds = {}; // Changed to Set
    matchesSnapshot.docs.forEach((doc) {
      final userIds = List<String>.from(doc['userIds']);
      userIds.remove(_currentUserId);
      // Since we are only adding one ID at a time, adding match IDs alongside this should be fine
      allUserIds.addAll(userIds);
      _matchIds.add(doc.id); // Store the document ID in the match IDs list
    });
    setState(() {
      _userDocuments =
          Map.fromIterable(allUserIds, key: (id) => id, value: (_) => {});
    });
  }

  Future<void> _loadUserDocuments() async {
    await Future.forEach(_userDocuments.keys, (userId) async {
      final userDocSnapshot = await FirebaseFirestore.instance
          .collection('test_users')
          .doc(userId)
          .get();
      final userData = userDocSnapshot.data();
      if (userData != null) {
        setState(() {
          _userDocuments[userId] = userData;
        });
      }
    });
    print('User documents loaded');
  }

  @override
  Widget build(BuildContext context) {
    final allUsersNotifier = Provider.of<AllUsersNotifier>(context);
    final matchProfilePictures = allUsersNotifier.matchProfilePictures;
    double? width;
    if (!kIsWeb)
      width = MediaQuery.of(context).size.width < 500 ? 500 : 500;
    else
      width = MediaQuery.of(context).size.width < 1000
          ? MediaQuery.of(context).size.width
          : 1000;
    return _currentUserId == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _userDocuments.isEmpty
            ? Center(
                child: Text('No matches found.'),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: width),
                    child: ListView.builder(
                      itemCount: _userDocuments.length,
                      itemBuilder: (context, index) {
                        final userId = _userDocuments.keys.elementAt(index);
                        final userData = _userDocuments[userId];
                        String? profilePicture = userData != null
                            ? userData['profilePictures'][0] ?? 'placeholder'
                            : 'placeholder';

                        return GestureDetector(
                          onTap: () {
                            // Navigate to Chat widget when tile is clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatWidget(
                                    profilePictureUrl: profilePicture!,
                                    matchId: _matchIds[
                                        index], // Use the match ID from the list
                                    uid: _currentUserId,
                                    notifier: allUsersNotifier),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Card(
                                  elevation: 3,
                                  child: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: profilePicture != 'placeholder'
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: profilePicture!,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.grey,
                                            child: Center(
                                              child: Text(
                                                'Hi',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 8),
                                        Text('More text')
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
  }
}
