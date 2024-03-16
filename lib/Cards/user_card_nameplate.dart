// This will display in the gray area on top of the box towards the bottom
// i.e. the user won't have to scroll down to see it

import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCardNameplateComponent extends StatefulWidget {
  final Map<String, dynamic> profile;
  const UserCardNameplateComponent({super.key, required this.profile});

  @override
  State<UserCardNameplateComponent> createState() =>
      _UserCardNameplateComponentState();
}

class _UserCardNameplateComponentState
    extends State<UserCardNameplateComponent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AllUsersNotifier allUsersNotifier = Provider.of<AllUsersNotifier>(context);
    print(widget.profile);
    return Card(
      elevation: 0,
      child: Container(
        width: 600,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.profile['name'] as String,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
