// Gonna leave matchWithGender property as-is rather than specify romantic
// Even though I'm distinguishing matchWithGenderFriendship
// Just b/c people already chose the option themselves during signup

import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Tiles/settings_tile_builder.dart';

class FriendshipPreferencesSettingsSection extends StatefulWidget {
  const FriendshipPreferencesSettingsSection({super.key});

  @override
  State<FriendshipPreferencesSettingsSection> createState() =>
      _FriendshipPreferencesSettingsSectionState();
}

class _FriendshipPreferencesSettingsSectionState
    extends State<FriendshipPreferencesSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: Text('Match Preferences (Friendship)'),
      tiles: [
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.solidHeart,
              firestorePropertyName: 'desiredGenderFriendship',
              options: [
                'Male',
                'Female',
                'Any',
              ],
              title: 'Desired Gender',
              myContext: context),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.plane,
              firestorePropertyName: 'canLongDistanceMatch',
              options: [
                'Yes',
                'No',
                'Maybe',
              ],
              title: 'Open to long-distance',
              myContext: context),
        ),
      ],
    );
  }
}
