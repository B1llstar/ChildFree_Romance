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
      home: QuestionPage(),
    );
  }
}

class QuestionPage extends StatefulWidget {
  final List<String>? otherButtons;

  QuestionPage({this.otherButtons});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
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
    nextPage();
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
      'property': 'doesDrink',
      'title': 'Do you drink alcohol?',
      'assetImageUrl': 'assets/mug.png',
      'options': ['Yes', 'No', 'Socially'],
    },
    {
      'property': 'doesSmoke',
      'title': 'Do you smoke?',
      'assetImageUrl': 'assets/cigar.png',
      'options': ['Yes', 'No', 'Socially'],
    },
    {
      'property': 'does420',
      'title': 'Do you partake?',
      'assetImageUrl': 'assets/plant.png',
      'options': ['Yes', 'No', 'Socially'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Page'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          return QuestionWidget(
            property: _questions[index]['property'],
            title: _questions[index]['title'],
            assetImageUrl: _questions[index]['assetImageUrl'],
            options: _questions[index]['options'],
            onButtonPressed: onButtonPressed,
            otherButtons: widget.otherButtons,
          );
        },
      ),
    );
  }
}
