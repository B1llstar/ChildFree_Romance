import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/profile_setup_notifier.dart';

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
                  'I am:',
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
                  GenderButton(
                      icon: Icons.male,
                      onPressed: () {
                        notifier.setOwnGender('Male');
                        checkAndAdvancePage(notifier, context);
                      },
                      isSelected: notifier.ownGender == 'Male'),
                  GenderButton(
                      icon: Icons.female,
                      onPressed: () {
                        notifier.setOwnGender('Female');
                        checkAndAdvancePage(notifier, context);
                      },
                      isSelected: notifier.ownGender == 'Female'),
                  GenderButton(
                    title: 'Other',
                    onPressed: () {
                      notifier.ownGender = 'Other';
                      checkAndAdvancePage(notifier, context);
                    },
                    isSelected: notifier.ownGender == 'Other',
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Looking for:',
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
                  GenderButton(
                    icon: Icons.male,
                    onPressed: () {
                      notifier.desiredGender = 'Male';
                      checkAndAdvancePage(notifier, context);
                    },
                    isSelected: notifier.desiredGender == 'Male',
                  ),
                  GenderButton(
                    icon: Icons.female,
                    onPressed: () {
                      notifier.desiredGender = 'Female';
                      checkAndAdvancePage(notifier, context);
                    },
                    isSelected: notifier.desiredGender == 'Female',
                  ),
                  GenderButton(
                    title: 'Any',
                    onPressed: () {
                      notifier.desiredGender = 'Any';
                      checkAndAdvancePage(notifier, context);
                    },
                    isSelected: notifier.desiredGender == 'Any',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void checkAndAdvancePage(
      ProfileSetupNotifier notifier, BuildContext context) {
    if (notifier.ownGender != null && notifier.desiredGender != null) {
      notifier.advancePage(context);
    }
  }
}

class GenderButton extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final VoidCallback onPressed;
  final bool isSelected;

  const GenderButton({
    this.icon,
    this.title,
    required this.onPressed,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color?>(
          isSelected ? Colors.green : null,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: icon != null
          ? Icon(
              icon,
              color: icon == Icons.male ? Colors.blue : Colors.pink,
              size: 30.0,
            )
          : Text(
              title!,
              style: TextStyle(
                fontSize: 18.0,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
    );
  }
}
