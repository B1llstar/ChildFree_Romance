import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/all_users_notifier.dart';

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

  @override
  void initState() {
    super.initState();
    _userDocuments = {};
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
    final List<String> allUserIds = [];
    matchesSnapshot.docs.forEach((doc) {
      final userIds = List<String>.from(doc['userIds']);
      userIds.remove(_currentUserId);
      allUserIds.addAll(userIds);
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
  }

  @override
  Widget build(BuildContext context) {
    final allUsersNotifier = Provider.of<AllUsersNotifier>(context);
    final matchIds = allUsersNotifier.matchIds;
    final matchProfilePictures = allUsersNotifier.matchProfilePictures;
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches'),
      ),
      body: _currentUserId == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _userDocuments.isEmpty
              ? Center(
                  child: Text('No matches found.'),
                )
              : ListView.builder(
                  itemCount: _userDocuments.length,
                  itemBuilder: (context, index) {
                    final userId = _userDocuments.keys.elementAt(index);
                    final userData = _userDocuments[userId];
                    String? profilePicture = userData != null
                        ? userData['profilePictures'][0] ?? 'placeholder'
                        : 'placeholder';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Profile Picture Card
                          Card(
                            elevation: 3,
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              child: profilePicture != 'placeholder'
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: profilePicture!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey,
                                      child: Center(
                                        child: Text(
                                          'Hi',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width: 16),
                          // Details Card
                          Expanded(
                            child: Card(
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      userData != null
                                          ? userData['name']
                                          : 'Unknown User',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Add more user details here if needed
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
