import 'package:childfree_romance/Cards/user_card_base_settings_component.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  final Map<String, dynamic> profile;
  const ProfileCard({Key? key, required this.profile}) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    // Get current user from our notifier
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width < 600
            ? MediaQuery.of(context).size.width
            : 600,
      ),
      child: Card(
        color: Colors.deepPurpleAccent,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.transparent,
                image: DecorationImage(
                  image: NetworkImage(
                      widget.profile['profilePictures'][0] ?? 'Crigne'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProfileCardBaseSettingsComponent(profile: widget.profile)
                ],
              ),
            ),
            SizedBox(height: 8),

            // Insert anything we want to appear outside the card here
          ],
        ),
      ),
    );
  }
}
