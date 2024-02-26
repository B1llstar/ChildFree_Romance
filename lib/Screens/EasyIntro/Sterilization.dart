import 'package:childfree_romance/Screens/EasyIntro/question_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SecondQuestionPage(),
    );
  }
}

class SecondQuestionPage extends StatefulWidget {
  final List<String>? otherButtons;

  SecondQuestionPage({this.otherButtons});

  @override
  _SecondQuestionPageState createState() => _SecondQuestionPageState();
}

class _SecondQuestionPageState extends State<SecondQuestionPage> {
  PageController? _pageController;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPageIndex < _questions.length - 1) {
      _pageController!
          .nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        currentPageIndex++;
      });
    }
  }

  void onButtonPressed(String property, String value) {
    print('$value pressed for property: $property');
    updatePropertyInFirestore(property, value);
    if (property == 'areSterilized' && value == 'No') {
      // If the user is not sterilized, show the second question
      nextPage();
    } else {
      // Otherwise, proceed to the next page
      Navigator.pop(context);
    }
  }

  void updatePropertyInFirestore(dynamic property, dynamic value) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      firestore
          .collection('users')
          .doc(user.uid)
          .set({property: value}, SetOptions(merge: true));
    }
  }

  List<Map<String, dynamic>> _questions = [
    {
      'property': 'areSterilized',
      'title': 'Are you sterilized?',
      'options': ['Yes', 'No'],
      'assetImageUrl': 'assets/stethoscope.png',
    },
    {
      'property': 'openToSterilization',
      'title': 'Are you open to sterilization?',
      'options': ['Yes', 'No', 'Maybe'],
      'assetImageUrl': 'assets/stethoscope.png',
    },
    {
      'property': 'openToSterilization',
      'title': 'Do you drink',
      'options': ['Yes', 'No', 'Sometimes'],
      'assetImageUrl': 'assets/stethoscope.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Question Page'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          return QuestionWidget(
            property: _questions[index]['property'],
            title: _questions[index]['title'],
            options: _questions[index]['options'],
            assetImageUrl: _questions[index]['assetImageUrl'],
            onButtonPressed: onButtonPressed,
            otherButtons: widget.otherButtons,
          );
        },
      ),
    );
  }
}
