// This will display in the gray area on top of the box towards the bottom
// i.e. the user won't have to scroll down to see it

import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileCardBaseSettingsComponentWeb extends StatefulWidget {
  final Map<String, dynamic> profile;
  const ProfileCardBaseSettingsComponentWeb({super.key, required this.profile});

  @override
  State<ProfileCardBaseSettingsComponentWeb> createState() =>
      _ProfileCardBaseSettingsComponentWebState();
}

class _ProfileCardBaseSettingsComponentWebState
    extends State<ProfileCardBaseSettingsComponentWeb> {
  int? _age;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calculateAge();
  }

  void _calculateAge() {
    Timestamp dobTimestamp =
        widget.profile['DOB']; // Assuming 'DOB' is the field name in Firestore
    DateTime dob = dobTimestamp.toDate();
    DateTime now = DateTime.now();
    int years = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    setState(() {
      _age = years;
    });
  }

  @override
  Widget build(BuildContext context) {
    AllUsersNotifier allUsersNotifier = Provider.of<AllUsersNotifier>(context);
    print(widget.profile);
    return Container(
      width: 600,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
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
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('')
            ],
          ),
          SizedBox(height: 4.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              _age != null ? '$_age years old' : 'Calculating age...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ]),
          SizedBox(height: 4),
          /*
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.profile['locale']['country'] == 'United States'
                    ? widget.profile['locale']['city'] != null
                        ? '${widget.profile['locale']['city']}, ${widget.profile['locale']['state']}'
                        : widget.profile['locale']['state']
                    : widget.profile['locale']['city'] != null
                        ? '${widget.profile['locale']['city']}, ${widget.profile['locale']['country']}'
                        : widget.profile['locale']['country'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          */

          SizedBox(height: 4),
          Row(
            children: [
              Text(
                  allUsersNotifier
                          .convertIsLookingForToCardString(widget.profile) ??
                      'Romance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  )),
            ],
          ),
          SizedBox(height: 4.0),
        ],
      ),
    );
  }
}
