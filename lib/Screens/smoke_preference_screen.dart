import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';

class SmokePreferenceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSetupNotifier>(
      builder: (context, notifier, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Smoke Preference'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Do you smoke?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '🚬',
                style: TextStyle(fontSize: 100.0),
              ),
              /*
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Icon(
                  Icons.smoking_rooms, // You can change the icon here
                  size: 100.0,
                ),
              ),*/
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmokeOptionCard(
                    title: 'Yes',
                    onPressed: () {
                      notifier.smokingPreference = SmokingPreference.yes;
                    },
                    isSelected:
                        notifier.smokingPreference == SmokingPreference.yes,
                  ),
                  SmokeOptionCard(
                    title: 'No',
                    onPressed: () {
                      notifier.smokingPreference = SmokingPreference.no;
                    },
                    isSelected:
                        notifier.smokingPreference == SmokingPreference.no,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmokeOptionCard(
                    title: 'Socially',
                    onPressed: () {
                      notifier.smokingPreference = SmokingPreference.socially;
                    },
                    isSelected: notifier.smokingPreference ==
                        SmokingPreference.socially,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class SmokeOptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;

  const SmokeOptionCard({
    required this.title,
    required this.onPressed,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(8.0),
        color:
            isSelected ? Colors.green : null, // Highlight in green if selected
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : Colors.black, // Text color based on selection
            ),
          ),
        ),
      ),
    );
  }
}
