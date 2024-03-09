// This will display in the gray area on top of the box towards the bottom
// i.e. the user won't have to scroll down to see it

import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileCardBaseSettingsComponent extends StatefulWidget {
  final Map<String, dynamic> profile;
  const ProfileCardBaseSettingsComponent({super.key, required this.profile});

  @override
  State<ProfileCardBaseSettingsComponent> createState() =>
      _ProfileCardBaseSettingsComponentState();
}

class _ProfileCardBaseSettingsComponentState
    extends State<ProfileCardBaseSettingsComponent> {
  @override
  Widget build(BuildContext context) {
    AllUsersNotifier allUsersNotifier = Provider.of<AllUsersNotifier>(context);
    print(widget.profile);
    return Container(
      width: 500,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.profile['age'].toString()} years old' ??
                    '18 years old',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
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
