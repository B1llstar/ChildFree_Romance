// For when we need a settings tile with one answer
// i.e. Do you smoke? Y/No/Sometimes

import 'package:childfree_romance/UserSettings/profile_picture_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class PhotoManagerSettingsTile extends StatefulWidget {
  const PhotoManagerSettingsTile({
    Key? key,
  }) : super(key: key);

  @override
  State<PhotoManagerSettingsTile> createState() =>
      _PhotoManagerSettingsTileState();
}

class _PhotoManagerSettingsTileState extends State<PhotoManagerSettingsTile> {
  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      backgroundColor: Colors.white,
      title: Text('Photos'),
      description: ProfilePicturesPage(),
    );
  }
}
