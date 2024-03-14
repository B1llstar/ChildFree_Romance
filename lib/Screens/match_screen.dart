import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MatchesListWidget extends StatefulWidget {
  @override
  _MatchesListWidgetState createState() => _MatchesListWidgetState();
}

class _MatchesListWidgetState extends State<MatchesListWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String placeholderImageUrl =
      'https://static.wikia.nocookie.net/shingekinokyojin/images/3/3c/Eren_Jaeger_%28Anime%29_character_image_%28850%29.png/revision/latest/scale-to-width/360?cb=20201228000236';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('matches')
            .where('userId1', isEqualTo: _auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<DocumentSnapshot> matchesUserId1 = snapshot.data!.docs;
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('matches')
                .where('userId2', isEqualTo: _auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final List<DocumentSnapshot> matchesUserId2 = snapshot.data!.docs;
              final List<DocumentSnapshot> allMatches = [
                ...matchesUserId1,
                ...matchesUserId2
              ];
              if (allMatches.isEmpty) {
                return Center(
                  child: Text('No matches found.'),
                );
              }
              return ListView.builder(
                itemCount: allMatches.length,
                itemBuilder: (context, index) {
                  final match = allMatches[index];
                  final userId1 = match['userId1'];
                  final userId2 = match['userId2'];
                  final otherUserId =
                      userId1 == _auth.currentUser!.uid ? userId2 : userId1;
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('test_users')
                        .doc(otherUserId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasData && snapshot.data!.exists) {
                        final profilePictureUrl =
                            'https://static.wikia.nocookie.net/shingekinokyojin/images/3/3c/Eren_Jaeger_%28Anime%29_character_image_%28850%29.png/revision/latest/scale-to-width/360?cb=20201228000236';
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(profilePictureUrl),
                          ),
                          title: Text('Match with $otherUserId'),
                          subtitle: Text('Match ID: ${match.id}'),
                        );
                      }
                      return SizedBox(); // Return an empty widget if no profile picture URL is available
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MatchesListWidget(),
  ));
}
