// Gonna leave matchWithGender property as-is rather than specify romantic
// Even though I'm distinguishing matchWithGenderFriendship
// Just b/c people already chose the option themselves during signup

import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Tiles/settings_tile_builder.dart';

class MatchPreferencesSettingsSection extends StatefulWidget {
  const MatchPreferencesSettingsSection({super.key});

  @override
  State<MatchPreferencesSettingsSection> createState() =>
      _MatchPreferencesSettingsSectionState();
}

class _MatchPreferencesSettingsSectionState
    extends State<MatchPreferencesSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: Text('Match Preferences'),
      tiles: [
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.solidHeart,
              firestorePropertyName: 'desiredGenderRomance',
              options: [
                'Male',
                'Female',
                'Any',
              ],
              title: 'Desired Gender (Romance)',
              myContext: context),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.userFriends,
              firestorePropertyName: 'desiredGenderFriendship',
              options: [
                'Male',
                'Female',
                'Any',
              ],
              title: 'Desired Gender (Friendship)',
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
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.infinity,
              firestorePropertyName: 'relationshipType',
              options: [
                'Monogamy',
                'Non-monogamy',
                'Open to anything',
                'Prefer not to say',
              ],
              title: 'Relationship Type',
              myContext: context),
        ),
      ],
    );
  }
}
