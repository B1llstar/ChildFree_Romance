import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import '../../promptSelectionWidget.dart';

class PromptSection extends StatefulWidget {
  const PromptSection({super.key});

  @override
  State<PromptSection> createState() => _PromptSectionState();
}

class _PromptSectionState extends State<PromptSection> {
  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: Text('Prompts'),
      tiles: [
        CustomSettingsTile(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: Colors.transparent,
                  ),
                  badgeContent: Text('*at least one prompt required',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            FirestorePromptsWidget(
                userId: FirebaseAuth.instance.currentUser!.uid),
          ],
        )),
      ],
    );
  }
}
