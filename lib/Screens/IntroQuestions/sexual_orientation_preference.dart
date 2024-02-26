import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/profile_setup_notifier.dart';

class SexualOrientationPreferenceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSetupNotifier>(
      builder: (context, notifier, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Sexual Orientation Preference'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'What\'s your sexual orientation?',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SexualOrientationOptionCard(
                    title: 'Heterosexual',
                    onPressed: () {
                      notifier.sexualOrientation = 'Heterosexual';
                    },
                    isSelected: notifier.sexualOrientation == 'Heterosexual',
                  ),
                  SexualOrientationOptionCard(
                    title: 'Homosexual',
                    onPressed: () {
                      notifier.sexualOrientation = 'Homosexual';
                    },
                    isSelected: notifier.sexualOrientation == 'Homosexual',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SexualOrientationOptionCard(
                    title: 'Bisexual',
                    onPressed: () {
                      notifier.sexualOrientation = 'Bisexual';
                    },
                    isSelected: notifier.sexualOrientation == 'Bisexual',
                  ),
                  SexualOrientationOptionCard(
                    title: 'Pansexual',
                    onPressed: () {
                      notifier.sexualOrientation = 'Pansexual';
                    },
                    isSelected: notifier.sexualOrientation == 'Pansexual',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SexualOrientationOptionCard(
                    title: 'Asexual',
                    onPressed: () {
                      notifier.sexualOrientation = 'Asexual';
                    },
                    isSelected: notifier.sexualOrientation == 'Asexual',
                  ),
                  SexualOrientationOptionCard(
                    title: 'Other',
                    onPressed: () {
                      notifier.sexualOrientation = 'Other';
                    },
                    isSelected: notifier.sexualOrientation == 'Other',
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

class SexualOrientationOptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;

  const SexualOrientationOptionCard({
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
