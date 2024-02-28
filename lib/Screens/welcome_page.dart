import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 400,
        width: 500,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Child-Free Romance!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ready to find your dream partner?',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              /*
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
              ),*/
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
      ),
    );
  }
}
