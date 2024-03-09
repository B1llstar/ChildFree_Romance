import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Tiles/settings_tile_builder.dart';

class EssentialsSettingsSection extends StatefulWidget {
  const EssentialsSettingsSection({super.key});

  @override
  State<EssentialsSettingsSection> createState() =>
      _EssentialsSettingsSectionState();
}

class _EssentialsSettingsSectionState extends State<EssentialsSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: Text('Essentials'),
      tiles: [
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
              firestorePropertyName: 'Sexuality',
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
              leadingIcon: FontAwesomeIcons.solidUser,
              firestorePropertyName: 'Gender',
              options: ['Male', 'Female', 'Non-binary', 'Other'],
              title: 'Gender',
              myContext: context),
        ),
        CustomSettingsTile(
          child: CustomSettingsTileSingleAnswer(
              leadingIcon: FontAwesomeIcons.solidUser,
              firestorePropertyName: 'Pronouns',
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
