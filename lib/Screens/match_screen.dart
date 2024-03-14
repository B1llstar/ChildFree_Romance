import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/all_users_notifier.dart';

class MatchesListWidget extends StatefulWidget {
  @override
  _MatchesListWidgetState createState() => _MatchesListWidgetState();
}

class _MatchesListWidgetState extends State<MatchesListWidget> {
  late String _currentUserId;
  late Stream<QuerySnapshot> _matchesStream;
  late Map<String, String> _userProfilePictures = {};

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
        _matchesStream = FirebaseFirestore.instance
            .collection('matches')
            .where('userIds', arrayContains: _currentUserId)
            .snapshots();
      });
      await _fetchUserProfilePictures(); // Fetch profile pictures after setting the current user
    }
  }

  Future<void> _fetchUserProfilePictures() async {
    QuerySnapshot usersSnapshot =
        await FirebaseFirestore.instance.collection('test_users').get();
    _userProfilePictures = Map.fromIterable(usersSnapshot.docs,
        key: (doc) => doc.id,
        value: (doc) => doc.data()['profilePictures'] != null &&
                (doc.data()['profilePictures'] as List).isNotEmpty
            ? (doc.data()['profilePictures'] as List)[0]
            : 'cringe');
    setState(() {}); // Update the UI after fetching data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches'),
      ),
      body: _currentUserId == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _matchesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No matches found.'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var match = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    List<String> userIds = List<String>.from(match['userIds']);
                    userIds.removeWhere((id) => id == _currentUserId);
                    String userId = userIds.isNotEmpty ? userIds[0] : 'cringe';
                    String? profilePicture = _userProfilePictures[userId];
                    print(match['userIdSwipedFirst']);
                    AllUsersNotifier _notifier =
                        Provider.of<AllUsersNotifier>(context, listen: false);

                    return ListTile(
                      leading: profilePicture != null
                          ? Container(height: 50, width: 50,
                            child: CachedNetworkImage(
                                imageUrl: profilePicture,
                                placeholder: (context, url) => Container(
                                    height: 50, width: 50, child: Placeholder()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                          )
                          : Container(
                              height: 50, width: 50, child: Placeholder()),
                      title: Text('Match ID: ${snapshot.data!.docs[index].id}'),
                      // Add more widgets to display match details
                    );
                  },
                );
              },
            ),
    );
  }
}
