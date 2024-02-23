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
                    title: 'Male',
                    onPressed: () {
                      notifier.setOwnGender(Gender.male);
                      checkAndAdvancePage(notifier, context);
                    },
                    isSelected: notifier.ownGender == Gender.male,
                  ),
                  GenderButton(
                    title: 'Female',
                    onPressed: () {
                      notifier.setOwnGender(Gender.female);
                      checkAndAdvancePage(notifier, context);
                    },
                    isSelected: notifier.ownGender == Gender.female,
                  ),
                  GenderButton(
                    title: 'Other',
                    onPressed: () {
                      notifier.setOwnGender(Gender.other);
                      checkAndAdvancePage(notifier, context);
                    },
                    isSelected: notifier.ownGender == Gender.other,
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
                    title: 'Male',
                    onPressed: () {
                      notifier.setDesiredGender(DesiredGender.male);
                      checkAndAdvancePage(notifier, context);
                    },
                    isSelected: notifier.desiredGender == DesiredGender.male,
                  ),
                  GenderButton(
                    title: 'Female',
                    onPressed: () {
                      notifier.setDesiredGender(DesiredGender.female);
                      checkAndAdvancePage(notifier, context);
                    },
                    isSelected: notifier.desiredGender == DesiredGender.female,
                  ),
                  GenderButton(
                    title: 'Any',
                    onPressed: () {
                      notifier.setDesiredGender(DesiredGender.any);
                      checkAndAdvancePage(notifier, context);
                    },
                    isSelected: notifier.desiredGender == DesiredGender.any,
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
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;

  const GenderButton({
    required this.title,
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
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
