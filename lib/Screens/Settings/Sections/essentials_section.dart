import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../Notifiers/all_users_notifier.dart';
import '../../../Notifiers/user_notifier.dart';
import '../Tiles/settings_tile_builder.dart';

class EssentialsSettingsSection extends StatefulWidget {
  const EssentialsSettingsSection({Key? key}) : super(key: key);

  @override
  State<EssentialsSettingsSection> createState() =>
      _EssentialsSettingsSectionState();
}

class _EssentialsSettingsSectionState extends State<EssentialsSettingsSection> {
  @override
  Widget build(BuildContext context) {
    AllUsersNotifier _notifier = Provider.of<AllUsersNotifier>(context);
    UserDataProvider _userDataProvider = Provider.of<UserDataProvider>(context);
    return SettingsSection(
      title: Text('Essentials'),
      tiles: [
        CustomSettingsTile(
          child: SettingsTile(
            title: Text('Job',
                style: TextStyle(
                    color: _notifier.darkMode ? Colors.white : Colors.black)),
            leading: Icon(FontAwesomeIcons.briefcase,
                color: _notifier.darkMode ? Colors.white : Colors.black),
            description: Text(_notifier.currentUser['job'] ?? ''),
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String newJob = _notifier.currentUser['job'] ??
                      ''; // Initialize with current job value
                  return AlertDialog(
                    title: Text('Enter your job'),
                    content: TextField(
                      onChanged: (value) {
                        newJob =
                            value; // Update newJob variable as the user types
                      },
                      decoration: InputDecoration(hintText: 'Job'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Update data provider and notifier with new job value
                          _userDataProvider.setProperty('job', newJob);
                          setState(() {
                            _notifier.currentUser['job'] = newJob;
                          });
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: Icons.school,
              firestorePropertyName: 'educationLevel',
              options: [
                'High School',
                'Undergrad',
                'Postgrad',
                'Prefer not to say'
              ],
              title: 'Education Level',
              myContext: context),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.briefcaseMedical,
              firestorePropertyName: 'sterilizationStatus',
              options: [
                'Sterilized',
                'Not Sterilized',
                'Will Sterilize',
              ],
              title: 'Sterilization Status',
              myContext: context),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              firestorePropertyName: 'sexuality',
              options: [
                'Straight',
                'Gay',
                'Lesbian',
                'Bisexual',
                'Allosexual',
                'Androsexual',
                'Asexual',
                'Autosexual',
                'Bicurious',
                'Demisexual',
                'Fluid',
                'Graysexual',
                'Gynesexual',
                'Monosexual',
                'Omnisexual',
                'Pansexual',
                'Polysexual',
                'Queer',
                'Skoliosexual',
                'Spectrasexual',
                'Not Sure',
                'Other'
              ],
              title: 'Sexuality',
              leadingIcon: FontAwesomeIcons.solidSmileWink,
              myContext: context),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              isImportant: true,
              leadingIcon: FontAwesomeIcons.solidStar,
              firestorePropertyName: 'gender',
              options: ['Male', 'Female', 'Non-binary', 'Other'],
              title: 'Gender',
              myContext: context),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.solidUser,
              firestorePropertyName: 'pronouns',
              options: [
                'He/Him',
                'She/Her',
                'They/Them',
              ],
              title: 'Pronouns',
              myContext: context),
        ),
      ],
    );
  }
}
