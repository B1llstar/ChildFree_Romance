// Gonna leave matchWithGender property as-is rather than specify romantic
// Even though I'm distinguishing matchWithGenderFriendship
// Just b/c people already chose the option themselves during signup

import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Tiles/settings_tile_builder.dart';

class MiscSettingsSection extends StatefulWidget {
  const MiscSettingsSection({super.key});

  @override
  State<MiscSettingsSection> createState() => _MiscSettingsSectionState();
}

class _MiscSettingsSectionState extends State<MiscSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: Text('Misc.'),
      tiles: [
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              firestorePropertyName: 'Vaccinated',
              options: [
                'Vaccinated',
                'Partly Vaccinated',
                'Not yet vaccinated',
                'Prefer not to say',
              ],
              title: 'Vaccination Status',
              leadingIcon: FontAwesomeIcons.syringe,
              myContext: context),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.solidStar,
              firestorePropertyName: 'zodiacSign',
              options: [
                'Aries',
                'Taurus',
                'Gemini',
                'Cancer',
                'Leo',
                'Virgo',
                'Libra',
                'Scorpio',
                'Sagittarius',
                'Capricorn',
                'Aquarius',
                'Pisces'
              ],
              title: 'Zodiac',
              myContext: context),
        ),
      ],
    );
  }
}
