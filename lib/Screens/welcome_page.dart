import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Child-Free Romance!',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '🎉',
              style: TextStyle(
                fontSize: 100.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Finding someone child-free can be hard.',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'No worries, we\'re here to help!',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Get the notifier and call advancePage method
                Provider.of<ProfileSetupNotifier>(context, listen: false)
                    .advancePage(context);
              },
              child: Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
