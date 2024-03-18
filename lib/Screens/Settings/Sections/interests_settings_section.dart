// Gonna leave matchWithGender property as-is rather than specify romantic
// Even though I'm distinguishing matchWithGenderFriendship
// Just b/c people already chose the option themselves during signup

import 'package:childfree_romance/interests_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:provider/provider.dart';

import '../../../Cards/interests_card.dart';
import '../../../Notifiers/all_users_notifier.dart';

class InterestsSettingsSection extends StatefulWidget {
  const InterestsSettingsSection({super.key});

  @override
  State<InterestsSettingsSection> createState() =>
      _InterestsSettingsSectionState();
}

class _InterestsSettingsSectionState extends State<InterestsSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: Text('Interests.'),
      tiles: [
        CustomSettingsTile(
            child: InterestsCard(
          options: interests,
          onInterestsChanged: (options) {
            Provider.of<AllUsersNotifier>(context, listen: false)
                .setSelectedInterests(options);
            print('Updating notifier');
            print(
                'Notifier values: ${Provider.of<AllUsersNotifier>(context, listen: false).selectedInterests}');
          },
        ))
      ],
    );
  }
}
