import 'package:childfree_romance/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../User/upload_profile_picture.dart';
import 'name_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: "dev@gmail.com", password: "testing");
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

  void previousPage() {
    if (currentPageIndex > 0) {
      _pageController!.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        currentPageIndex--;
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
      'property': 'does420',
      'title': 'Are you sterilized?',
      'options': ['Sterilized', 'Not Sterilized', 'Will Sterilize'],
      'assetImageUrl': 'assets/plant.png',
    },
    {
      'property': 'willRelocate',
      'title': 'Are you willing to relocate?',
      'options': ['Yes', 'No', 'Maybe'],
      'assetImageUrl': 'assets/globe.png',
    },
    {
      'property': 'willDoLongDistance',
      'title': 'Are you open to long-distance?',
      'options': ['Yes', 'No'],
      'assetImageUrl': 'assets/globe.png',
    },
    {
      'property': 'willDoLongDistance',
      'title': 'Are you willing to relocate?',
      'options': ['Yes', 'No', 'Maybe '],
      'assetImageUrl': 'assets/globe.png',
    },
    {
      'property': 'doesDrink',
      'title': 'Do you drink alcohol?',
      'options': ['Yes', 'No', 'Socially'],
      'assetImageUrl': 'assets/mug.png',
    },
    {
      'property': 'doesSmoke',
      'title': 'Do you smoke?',
      'options': ['Yes', 'No', 'Socially'],
      'assetImageUrl': 'assets/cigar.png',
    },
    {
      'property': 'does420',
      'title': 'Do you partake?',
      'options': ['Yes', 'No', 'Socially'],
      'assetImageUrl': 'assets/plant.png',
    },
    {
      'property': 'interests',
      'title': 'Choose Some Interests',
      'options': [
        'Animals',
        'Art',
        'Astrology',
        'Baking',
        'Board Games',
        'Camping',
        'Calligraphy',
        'Coding',
        'Cooking',
        'Crocheting',
        'Dancing',
        'DIY Projects',
        'Fashion',
        'Fashion Design',
        'Fishing',
        'Fitness',
        'Gardening',
        'Graphic Design',
        'History',
        'Hiking',
        'Interior Design',
        'Knitting',
        'Languages',
        'Magic Tricks',
        'Meditation',
        'Movies',
        'Music',
        'Painting',
        'Photography',
        'Podcasting',
        'Puzzles',
        'Reading',
        'Rowing',
        'Running',
        'Science',
        'Sculpting',
        'Self-Care',
        'Singing',
        'Sports',
        'Technology',
        'Theater',
        'Travel',
        'Video Games',
        'Volunteering',
        'Writing',
        'Yoga'
      ],
      'assetImageUrl': 'assets/stethoscope.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: Text('Question Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _questions.length + 2,
              itemBuilder: (context, index) {
                if (index == 0)
                  return NamePage(
                    onNextPressed: (String name) {},
                  );
                if (index == 1)
                  return ProfilePictureUpload(
                    onNextPressed: () {},
                  );
                return _buildQuestionWidget(_questions[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: previousPage,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: nextPage,
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionWidget(Map<String, dynamic> question) {
    return QuestionWidget(
      property: question['property'],
      title: question['title'],
      assetImageUrl: question['assetImageUrl'],
      options: question['options'],
      onButtonPressed: onButtonPressed,
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final String property;
  final String title;
  final String assetImageUrl;
  final List<String> options;
  final void Function(String, String) onButtonPressed;

  const QuestionWidget({
    Key? key,
    required this.property,
    required this.title,
    required this.assetImageUrl,
    required this.options,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: property == 'interests' ? 600 : 400,
          width: 500,
          child: Card(
            elevation: 2,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  if (property == 'interests')
                    _buildInterestsQuestionCard()
                  else
                    _buildNormalQuestionCard(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalQuestionCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          assetImageUrl,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var option in options)
              ElevatedButton(
                onPressed: () {
                  onButtonPressed(property, option);
                },
                child: Text(option),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInterestsQuestionCard() {
    return InterestsQuestionCard(
      options: options,
      onInterestsSelected: (selectedInterests) {
        onButtonPressed(property, selectedInterests.join(', '));
      },
    );
  }
}

class InterestsQuestionCard extends StatefulWidget {
  final List<String> options;
  final void Function(List<String>) onInterestsSelected;

  const InterestsQuestionCard({
    Key? key,
    required this.options,
    required this.onInterestsSelected,
  }) : super(key: key);

  @override
  _InterestsQuestionCardState createState() => _InterestsQuestionCardState();
}

class _InterestsQuestionCardState extends State<InterestsQuestionCard> {
  List<String> selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 400, // Set your desired height here
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                for (var interest in widget.options)
                  ChoiceChip(
                    label: Text(interest),
                    selected: selectedInterests.contains(interest),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedInterests.add(interest);
                        } else {
                          selectedInterests.remove(interest);
                        }
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            widget.onInterestsSelected(selectedInterests);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
