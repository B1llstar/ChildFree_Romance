import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Tiles/settings_tile_builder.dart';

class PersonalBeliefsSettingsSection extends StatefulWidget {
  const PersonalBeliefsSettingsSection({super.key});

  @override
  State<PersonalBeliefsSettingsSection> createState() =>
      _PersonalBeliefsSettingsSectionState();
}

class _PersonalBeliefsSettingsSectionState
    extends State<PersonalBeliefsSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: Text('Personal Beliefs'),
      tiles: [
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              firestorePropertyName: 'politicalViews',
              leadingIcon: FontAwesomeIcons.landmark,
              options: [
                'Liberal',
                'Moderate',
                'Conservative',
                'Not Political',
                'Other'
              ],
              title: 'Political Views',
              myContext: context),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              firestorePropertyName: 'religion',
              leadingIcon: FontAwesomeIcons.pray,
              options: [
                'Agnostic',
                'Atheist',
                'Buddhist',
                'Catholic',
                'Christian',
                'Hindu',
                'Jewish',
                'Muslim',
                'Sikh',
                'Spiritual',
                'Other',
                'Prefer not to say'
              ],
              title: 'Religion',
              myContext: context),
        ),
      ],
    );
  }
}
