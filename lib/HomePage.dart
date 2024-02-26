import 'package:flutter/material.dart';

import 'Screens/EasyIntro/DrinkSmoke420.dart';
import 'Screens/User/upload_profile_picture.dart';

class ProfileAndQuestionsPage extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        ProfilePictureUpload(onPictureUploaded: () {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }),
        QuestionPage(),
      ],
    );
  }
}
