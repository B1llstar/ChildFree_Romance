import 'package:childfree_romance/Screens/sterilization_option.dart';
import 'package:childfree_romance/Screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';
import 'choose_gender_preference.dart';
import 'dob_selection.dart';
import 'drink_preference_screen.dart';
import 'interests_page.dart';
import 'sexual_orientation_preference.dart'; // Import the new screen
import 'smoke_preference_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late PageController _pageController;

  List<String> buttonNames = [
    'Welcome',
    'Gender',
    'Sexuality',
    'Drink',
    'Smoke',
    'Interests',
    'DOB',
    'Sterilization Status', // Add the new button name
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void setSelectedIndex(int index) {
    _pageController.jumpToPage(index);
    Provider.of<ProfileSetupNotifier>(context, listen: false)
        .setCurrentPageIndex(index);
  }

  void nextPage() {
    if (_pageController.page! < buttonNames.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: BouncingScrollPhysics(),
                onPageChanged: (index) {
                  Provider.of<ProfileSetupNotifier>(context, listen: false)
                      .setCurrentPageIndex(index);
                },
                children: [
                  WelcomePage(),
                  GenderPreferenceScreen(),
                  SexualOrientationPreferenceScreen(),
                  DrinkPreferenceScreen(),
                  SmokePreferenceScreen(),
                  InterestsPage(),
                  DateOfBirthPreferenceScreen(),
                  SterilizationStatusPage(), // Add the new screen here
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: previousPage,
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: nextPage,
                  child: Text('Next'),
                ),
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
                      onPressed: setSelectedIndex,
                      isSelected: i ==
                          Provider.of<ProfileSetupNotifier>(context)
                              .currentPageIndex,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BreadCrumbButtonItem extends StatefulWidget {
  final String buttonText;
  final int index;
  final bool isSelected;
  final void Function(int) onPressed;

  const BreadCrumbButtonItem({
    required this.buttonText,
    required this.index,
    required this.onPressed,
    required this.isSelected,
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
          widget.isSelected ? Colors.blue : Colors.white,
        ),
      ),
      onPressed: () {
        widget.onPressed(widget.index);
      },
      child: Text(
        widget.buttonText,
        style: TextStyle(
          color: widget.isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
