import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package

import '../Notifiers/profile_setup_notifier.dart';

class DrinkPreferenceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSetupNotifier>(
      builder: (context, notifier, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Drink Preference'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Do you drink?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '🍺', style: TextStyle(fontSize: 100.0),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DrinkOptionCard(
                    title: 'Yes',
                    onPressed: () {
                      notifier.drinkingPreference = DrinkingPreference.yes;
                    },
                    isSelected:
                        notifier.drinkingPreference == DrinkingPreference.yes,
                  ),
                  DrinkOptionCard(
                    title: 'No',
                    onPressed: () {
                      notifier.drinkingPreference = DrinkingPreference.no;
                    },
                    isSelected:
                        notifier.drinkingPreference == DrinkingPreference.no,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DrinkOptionCard(
                    title: 'Socially',
                    onPressed: () {
                      notifier.drinkingPreference = DrinkingPreference.socially;
                    },
                    isSelected: notifier.drinkingPreference ==
                        DrinkingPreference.socially,
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

class DrinkOptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;

  const DrinkOptionCard({
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
