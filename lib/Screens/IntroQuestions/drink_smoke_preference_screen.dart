import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/profile_setup_notifier.dart';

class DrinkSmokePreferenceScreen extends StatefulWidget {
  @override
  _DrinkSmokePreferenceScreenState createState() =>
      _DrinkSmokePreferenceScreenState();
}

class _DrinkSmokePreferenceScreenState
    extends State<DrinkSmokePreferenceScreen> {
  bool hasTappedDrinkButton = false;
  bool hasTappedSmokeButton = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSetupNotifier>(
      builder: (context, notifier, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Drink & Smoke Preference'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !hasTappedDrinkButton
                  ? Column(
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
                        Image.asset('assets/mug.png', height: 150),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DrinkSmokeOptionCard(
                              title: 'Yes',
                              onPressed: () {
                                notifier.drinkingPreference = 'Yes';

                                setState(() {
                                  hasTappedDrinkButton = true;
                                });
                              },
                              isSelected: notifier.drinkingPreference == 'Yes',
                            ),
                            DrinkSmokeOptionCard(
                              title: 'No',
                              onPressed: () {
                                notifier.drinkingPreference = 'No';

                                setState(() {
                                  hasTappedDrinkButton = true;
                                });
                              },
                              isSelected: notifier.drinkingPreference == 'No',
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DrinkSmokeOptionCard(
                              title: 'Socially',
                              onPressed: () {
                                notifier.drinkingPreference = 'Socially';
                                setState(() {
                                  hasTappedDrinkButton = true;
                                });
                              },
                              isSelected:
                                  notifier.drinkingPreference == 'Socially',
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
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
                        Image.asset('assets/cigar.png', height: 150),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DrinkSmokeOptionCard(
                              title: 'Yes',
                              onPressed: () {
                                notifier.smokingPreference = 'Yes';
                                setState(() {
                                  hasTappedSmokeButton = true;
                                });
                                if (hasTappedDrinkButton) {
                                  notifier.advancePage(context);
                                }
                              },
                              isSelected: notifier.smokingPreference == 'Yes',
                            ),
                            DrinkSmokeOptionCard(
                              title: 'No',
                              onPressed: () {
                                notifier.smokingPreference = 'No';

                                setState(() {
                                  hasTappedSmokeButton = true;
                                });
                                if (hasTappedDrinkButton) {
                                  notifier.advancePage(context);
                                }
                              },
                              isSelected: notifier.smokingPreference == 'No',
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DrinkSmokeOptionCard(
                              title: 'Socially',
                              onPressed: () {
                                notifier.smokingPreference = 'Socially';
                                setState(() {
                                  hasTappedSmokeButton = true;
                                });
                                if (hasTappedDrinkButton) {
                                  notifier.advancePage(context);
                                }
                              },
                              isSelected:
                                  notifier.smokingPreference == 'Socially',
                            ),
                          ],
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

class DrinkSmokeOptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;

  const DrinkSmokeOptionCard({
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
