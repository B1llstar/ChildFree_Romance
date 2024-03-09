import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Tiles/settings_tile_builder.dart';

class LifestyleSettingsSection extends StatefulWidget {
  const LifestyleSettingsSection({super.key});

  @override
  State<LifestyleSettingsSection> createState() =>
      _LifestyleSettingsSectionState();
}

class _LifestyleSettingsSectionState extends State<LifestyleSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: Text('Lifestyle'),
      tiles: [
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.beer,
              firestorePropertyName: 'doesDrink',
              options: [
                'Yes',
                'No',
                'Socially',
              ],
              title: 'Drinking',
              myContext: context),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.smoking,
              firestorePropertyName: 'doesSmoke',
              options: [
                'Yes',
                'No',
                'Socially',
              ],
              title: 'Smoking',
              myContext: context),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.cannabis,
              firestorePropertyName: 'does420',
              options: [
                'Yes',
                'No',
                'Socially',
              ],
              title: 'Marijuana',
              myContext: context),
        ),
      ],
    );
  }
}
