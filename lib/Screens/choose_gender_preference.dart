import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';

class GenderPreferenceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSetupNotifier>(
      builder: (context, notifier, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Gender Preference'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'What\'s your gender identity?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenderOptionCard(
                    title: 'Male',
                    cardIcon: Icons.male,
                    iconColor: Colors.blue,
                    onPressed: () {
                      notifier.genderIdentity = GenderIdentity.male;
                    },
                    isSelected: notifier.genderIdentity == GenderIdentity.male,
                  ),
                  GenderOptionCard(
                    title: 'Female',
                    cardIcon: Icons.female,
                    iconColor: Colors.pink,
                    onPressed: () {
                      notifier.genderIdentity = GenderIdentity.female;
                    },
                    isSelected:
                        notifier.genderIdentity == GenderIdentity.female,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenderOptionCard(
                    title: 'Other',
                    onPressed: () {
                      notifier.genderIdentity = GenderIdentity.other;
                    },
                    isSelected: notifier.genderIdentity == GenderIdentity.other,
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

class GenderOptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData? cardIcon;
  final Color? iconColor;
  final bool isSelected;

  const GenderOptionCard({
    required this.title,
    required this.onPressed,
    this.cardIcon,
    this.iconColor,
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
          child: Row(
            children: [
              if (cardIcon != null)
                Icon(
                  cardIcon,
                  size: 24.0,
                  color: iconColor,
                ),
              SizedBox(width: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : Colors.black, // Text color based on selection
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
