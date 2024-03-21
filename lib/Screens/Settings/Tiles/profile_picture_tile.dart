// For when we need a settings tile with one answer
// i.e. Do you smoke? Y/No/Sometimes

import 'package:childfree_romance/UserSettings/profile_picture_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:provider/provider.dart';

import '../../../Notifiers/all_users_notifier.dart';

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
    AllUsersNotifier notifier = Provider.of<AllUsersNotifier>(context);
    return SettingsTile(
      backgroundColor:
          notifier.darkMode ? Color(0xFF222222) : Color(0xFFA6E7FF),
      title: Container(child: Text('To re-order, tap, hold and drag!')),
      description: ProfilePicturesPage(),
    );
  }
}
