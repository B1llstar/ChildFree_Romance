import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/all_users_notifier.dart';

class SwipedItemsGrid extends StatefulWidget {
  const SwipedItemsGrid({Key? key}) : super(key: key);

  @override
  _SwipedItemsGridState createState() => _SwipedItemsGridState();
}

class _SwipedItemsGridState extends State<SwipedItemsGrid> {
  late String _uid;
  late Future<List<Map<String, dynamic>>> _swipedItemsFuture;

  @override
  void initState() {
    super.initState();
    _initializeUID();
  }

  Future<void> _initializeUID() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _uid = user.uid;
        _fetchSwipedItems(); // Call the method to fetch swiped items
      });
    } else {
      // Handle the case when the user is not authenticated
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSwipedItems() async {
    AllUsersNotifier allUsersNotifier =
        Provider.of<AllUsersNotifier>(context, listen: false);
    List<Map<String, dynamic>> allProfiles = allUsersNotifier.profiles;
    List<Map<String, dynamic>> swipedItems = [];

    for (var profile in allProfiles) {
      // Check if the profile has been swiped
      bool isSwiped = profile.containsKey('swipedUserId');
      if (isSwiped) {
        swipedItems.add(profile);
      }
    }

    return swipedItems;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _swipedItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> swipedItems = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.8,
            ),
            itemCount: swipedItems.length,
            itemBuilder: (context, index) {
              return _buildGridItem(context, swipedItems[index]);
            },
          );
        }
      },
    );
  }

  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                item['profilePictures'][0] ?? item['profilePicture'] ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item['displayName'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
