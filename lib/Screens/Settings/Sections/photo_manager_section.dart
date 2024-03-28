import 'package:badges/badges.dart' as badges;
import 'package:childfree_romance/Screens/Settings/Tiles/profile_picture_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class PhotoManagerSection extends StatefulWidget {
  const PhotoManagerSection({super.key});

  @override
  State<PhotoManagerSection> createState() => _PhotoManagerSectionState();
}

class _PhotoManagerSectionState extends State<PhotoManagerSection> {
  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: Text('Photos'),
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
                  badgeContent: Text('*at least one photo required',
                      style: TextStyle(color: Colors.red)),
                ), // Adjust spacing between title and badge
              ],
            ),
            PhotoManagerSettingsTile(),
          ],
        ))
      ],
    );
  }
}
