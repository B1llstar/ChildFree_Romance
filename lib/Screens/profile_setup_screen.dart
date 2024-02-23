import 'package:childfree_romance/Screens/childfree_declaration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';
import 'choose_gender_preference.dart';
import 'dob_selection.dart';
import 'dream_partner_screen.dart';
import 'drink_smoke_preference_screen.dart';
import 'long_distance_page.dart';
import 'no_children_reason_screen.dart';
import 'sterilization_option.dart';
import 'welcome_page.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> buttonNames = [
      'Welcome',
      '♂️♀️',
      // 'Sexuality',
      '🩺',
      '🌎  ',
      '🥂',
      '🙅🧒',
      '😊💑',
      'DOB',
      'Done'
    ];
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller:
                    Provider.of<ProfileSetupNotifier>(context).pageController,
                physics: BouncingScrollPhysics(),
                onPageChanged: (index) {
                  Provider.of<ProfileSetupNotifier>(context, listen: false)
                      .setCurrentPageIndex(index);
                },
                children: [
                  WelcomePage(),
                  GenderPreferenceScreen(),
                  // SexualOrientationPreferenceScreen(),
                  SterilizationStatusPage(), // Add the new screen here
                  LongDistancePreferenceScreen(),
                  DrinkSmokePreferenceScreen(),
                  // DrinkPreferenceScreen(),
                  // SmokePreferenceScreen(),
                  NoChildrenReasonScreen(),
                  DreamPartnerScreen(),
                  DateOfBirthPreferenceScreen(),
                  ChildfreeDeclarationPage()
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*
                ElevatedButton(
                  onPressed: () {
                    Provider.of<ProfileSetupNotifier>(context, listen: false)
                        .previousPage();
                  },
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<ProfileSetupNotifier>(context, listen: false)
                        .nextPage();
                  },
                  child: Text('Next'),
                ),*/
              ],
            ),
            BreadCrumb(
              items: [
                for (int i = 0; i < buttonNames.length; i++)
                  BreadCrumbItem(
                    disableColor: Colors.transparent,
                    color: Colors.transparent,
                    content: BreadCrumbButtonItem(
                      buttonText: buttonNames[i],
                      index: i,
                      onPressed: (index) {
                        Provider.of<ProfileSetupNotifier>(context,
                                listen: false)
                            .pageController
                            .jumpToPage(index);
                        Provider.of<ProfileSetupNotifier>(context,
                                listen: false)
                            .setCurrentPageIndex(index);
                      },
                      isSelected: i ==
                          Provider.of<ProfileSetupNotifier>(context)
                              .currentPageIndex,
                      hasValue: _checkValue(i, context),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Validators to determine user progress in the setup process
  // They change the color of the breadcrumb bar
  bool _checkValue(int index, BuildContext context) {
    ProfileSetupNotifier notifier = Provider.of<ProfileSetupNotifier>(context);
    switch (index) {
      case 0:
        // Check if value is present for Welcome page (if any)
        return false;
      case 1:
        return notifier.desiredGender != null;
      case 2:
        //  return notifier.sexualOrientation != null;

        return notifier.sterilizationStatus != null;
      case 3:
        // return notifier.drinkingPreference != null;
        return notifier.longDistancePreference != null;
      case 4:
        return (notifier.smokingPreference != null &&
                notifier.drinkingPreference != null) !=
            null;
      case 5:
        // Check if value is present for Interests page (if any)
        return notifier.noChildrenReason != null &&
            notifier.noChildrenReason!.isNotEmpty &&
            notifier.noChildrenReason!.length > 20;
      // return false;
      case 6:
        // Check if value is present for DOB page (if any)
        return ((notifier.whyImYourDreamPartner != null &&
                    notifier.whyImYourDreamPartner!.isNotEmpty &&
                    notifier.whyImYourDreamPartner!.length >= 20) &&
                notifier.myDesiredPartner!.isNotEmpty &&
                notifier.myDesiredPartner!.length >= 20) !=
            null;
      // return false;
      case 7:
        return notifier.isAtLeast18YearsOld();
      case 8:
        return notifier.sterilizationStatus != null;
      default:
        return false;
    }
  }
}

class BreadCrumbButtonItem extends StatefulWidget {
  final String buttonText;
  final int index;
  final bool isSelected; // Add isSelected property
  final bool hasValue;
  final void Function(int) onPressed;

  const BreadCrumbButtonItem({
    required this.buttonText,
    required this.index,
    required this.isSelected,
    required this.hasValue,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<BreadCrumbButtonItem> createState() => _BreadCrumbButtonItemState();
}

class _BreadCrumbButtonItemState extends State<BreadCrumbButtonItem> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          widget.hasValue
              ? Colors.green
              : (widget.isSelected ? Colors.blue : Colors.white),
          // Change color to green if value present, maintain isSelected color otherwise
        ),
      ),
      onPressed: () {
        widget.onPressed(widget.index);
      },
      child: Text(
        widget.buttonText,
        style: TextStyle(
          color: widget.hasValue
              ? Colors.white
              : (widget.isSelected ? Colors.white : Colors.black),
          // Text color based on value present or isSelected
        ),
      ),
    );
  }
}
