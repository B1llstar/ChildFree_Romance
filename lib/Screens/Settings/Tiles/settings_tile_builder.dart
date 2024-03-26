// For when we need a settings tile with one answer
// i.e. Do you smoke? Y/No/Sometimes

import 'package:badges/badges.dart' as badges;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:provider/provider.dart';

import '../../../Notifiers/all_users_notifier.dart';
import '../../../Notifiers/user_notifier.dart';

class CustomSettingsTileSingleAnswer extends StatefulWidget {
  final String firestorePropertyName;
  final String title;
  final List<String> options;
  final IconData? leadingIcon;
  final BuildContext myContext;
  final bool isImportant;
  const CustomSettingsTileSingleAnswer(
      {Key? key,
      required this.firestorePropertyName,
      required this.options,
      required this.title,
      this.leadingIcon,
      required this.myContext,
      this.isImportant = false})
      : super(key: key);

  @override
  State<CustomSettingsTileSingleAnswer> createState() =>
      _CustomSettingsTileSingleAnswerState();
}

class _CustomSettingsTileSingleAnswerState
    extends State<CustomSettingsTileSingleAnswer> {
  @override
  Widget build(BuildContext context) {
    String description = Provider.of<UserDataProvider>(widget.myContext)
            .getProperty(widget.firestorePropertyName) ??
        '';
    AllUsersNotifier allUsersNotifier =
        Provider.of<AllUsersNotifier>(widget.myContext, listen: false);

    return SettingsTile(
      title: widget.isImportant
          ? Row(
              children: [
                Text(widget.title),
                SizedBox(width: 5), // Adjust spacing between title and badge
                badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: Colors.transparent,
                  ),
                  badgeContent:
                      Text('*required', style: TextStyle(color: Colors.red)),
                ),
              ],
            )
          : Text(widget.title),
      description: Text(description),
      leading: Icon(widget.leadingIcon,
          size: 32,
          color: !kIsWeb &&
                  Provider.of<AllUsersNotifier>(widget.myContext, listen: false)
                      .darkMode
              ? Colors.white
              : Colors.black),
      onPressed: (BuildContext context) {
        _showConfirmationDialog(
          widget.title,
          widget.firestorePropertyName,
          widget.options,
        );
      },
    );
  }

  // Show a dialog based on the options
  // Set the property equal to the chosen option
  // Takes the Title (To display whatever the user should see)
  // As well as the Name of the Property, and the Options (or possible values)
  Future<void> _showConfirmationDialog(
      String title, String nameOfProperty, List<String> options) async {
    print('Title: $title');
    final selectedOption = await showDialog<String>(
      context: widget.myContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options.map((option) {
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    Provider.of<UserDataProvider>(widget.myContext,
                            listen: false)
                        .setProperty(nameOfProperty, option);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
