import 'package:flutter/material.dart';

class ProfileCardInterestsComponent extends StatefulWidget {
  final Map<String, dynamic> profile;
  const ProfileCardInterestsComponent({super.key, required this.profile});

  @override
  State<ProfileCardInterestsComponent> createState() =>
      _ProfileCardInterestsComponentState();
}

class _ProfileCardInterestsComponentState
    extends State<ProfileCardInterestsComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Column(
          children: [
            Text(
              'Interests',
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (widget.profile['selectedInterests'] as List<dynamic>)
                  .map((interest) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(label: Text(interest)),
                      ))
                  .toList(),
            ),
          ],
        ));
  }
}
