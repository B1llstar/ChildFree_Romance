import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/profile_setup_notifier.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late ProfileSetupNotifier _profileSetupNotifier;

  @override
  void initState() {
    super.initState();
    _profileSetupNotifier =
        Provider.of<ProfileSetupNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'User Profile',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                _buildProfileItem('Smoking Preference',
                    _profileSetupNotifier.smokingPreference ?? 'Not set'),
                _buildProfileItem('Drinking Preference',
                    _profileSetupNotifier.drinkingPreference ?? 'Not set'),
                _buildProfileItem('Desired Gender',
                    _profileSetupNotifier.desiredGender ?? 'Not set'),
                _buildProfileItem('Date of Birth',
                    _profileSetupNotifier.dateOfBirth?.toString() ?? 'Not set'),
                _buildProfileItem('Sexual Orientation',
                    _profileSetupNotifier.sexualOrientation ?? 'Not set'),
                _buildProfileItem('Sterilization Status',
                    _profileSetupNotifier.sterilizationStatus ?? 'Not set'),
                _buildProfileItem(
                    'Long Distance Preference',
                    _profileSetupNotifier.longDistancePreference?.toString() ??
                        'Not set'),
                _buildProfileItem(
                    'Willing to Relocate',
                    _profileSetupNotifier.isWillingToRelocate?.toString() ??
                        'Not set'),
                _buildProfileItem(
                    'Own Gender', _profileSetupNotifier.ownGender ?? 'Not set'),
                _buildProfileItem('No Children Reason',
                    _profileSetupNotifier.noChildrenReason ?? 'Not set'),
                _buildProfileItem('Why I\'m Your Dream Partner',
                    _profileSetupNotifier.whyImYourDreamPartner ?? 'Not set'),
                _buildProfileItem('My Dream Partner',
                    _profileSetupNotifier.myDesiredPartner ?? 'Not set'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(width: 5.0),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}
