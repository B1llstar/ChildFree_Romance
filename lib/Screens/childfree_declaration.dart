import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';
import '../Utils/debug_utils.dart';

class ChildfreeDeclarationPage extends StatefulWidget {
  @override
  _ChildfreeDeclarationPageState createState() =>
      _ChildfreeDeclarationPageState();
}

class _ChildfreeDeclarationPageState extends State<ChildfreeDeclarationPage> {
  ProfileSetupNotifier? _profileSetupNotifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileSetupNotifier =
        Provider.of<ProfileSetupNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Childfree Declaration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: Text(
                "I solemnly swear that I do not have children, and am certain that I will never, EVER want them. Ever. Seriously, my mind is made up.",
                style: TextStyle(fontSize: 16.0),
              ),
              value: _profileSetupNotifier!.hasSolemnlySwore,
              onChanged: (value) {
                setState(() {
                  _profileSetupNotifier!.hasSolemnlySwore =
                      !_profileSetupNotifier!.hasSolemnlySwore;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _profileSetupNotifier!.uploadUser();
              },
              child: Text('Done'),
            ),
            ElevatedButton(
              onPressed: () async {
                DebugUtils.printDebug('Generating User Profile');
                String profile = await _profileSetupNotifier!
                    .generateAITextForProperty(
                        'My dream partner would be', 500);
                DebugUtils.printDebug(
                    'Now accessible in the childfree declaration page: ' +
                        profile);
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
