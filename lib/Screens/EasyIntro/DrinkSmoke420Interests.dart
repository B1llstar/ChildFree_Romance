import 'package:childfree_romance/Screens/EasyIntro/question.dart';
import 'package:childfree_romance/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../User/upload_profile_picture.dart';
import 'message_page_only.dart';
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

  void goToPage(int index) {
    _pageController!.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    setState(() {
      currentPageIndex = index;
    });
  }

  void nextPage() {
    print('Going to next page');
    if (currentPageIndex < _questions.length) {
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

  final List<String> breadcrumbItemNames = [
    'Basics',
    'Vices',
    'Preferences',
    'Interests'
  ];

  List<Map<String, dynamic>> _questions = [
    {
      'property': 'does420',
      'title': 'Placeholder',
      'options': [],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'does420',
      'title': 'Placeholder',
      'options': [],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'does420',
      'title': 'What are you looking for?',
      'options': ['Romance', 'Friendship', 'Anything'],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'does420',
      'title': 'Are you sterilized?',
      'options': ['Yes', 'No', 'Eventually'],
      'assetImageUrl': 'assets/stethoscope.png',
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
      'options': ['Yes', 'No', 'Sometimes'],
      'assetImageUrl': 'assets/mug.png',
    },
    {
      'property': 'doesSmoke',
      'title': 'Do you smoke?',
      'options': ['Yes', 'No', 'Sometimes'],
      'assetImageUrl': 'assets/cigar.png',
    },
    {
      'property': 'does420',
      'title': 'Do you partake?',
      'options': ['Yes', 'No', 'Sometimes'],
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
    final List<String> pageTitles = [
      'Basics',
      'Vices',
      'Preferences',
      'Interests'
    ];

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: Text('Question Page'),
      ),
      body: Column(
        children: [
          BreadCrumb(
            items: pageTitles.asMap().entries.map((entry) {
              final index = entry.key;
              final title = entry.value;
              return BreadCrumbItem(
                content: Text(title),
                onTap: () {
                  // Navigate to the corresponding page based on the index
                  navigateToPage(context, index);
                },
              );
            }).toList(),
            divider: Icon(Icons.chevron_right),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _questions.length + 4, // Corrected item count
              itemBuilder: (context, index) {
                if (index == _questions.length + 2) {
                  // Adjusted index
                  return MessagePage(
                      title: 'Thanks for answering!', description: '');
                }
                if (index == 0)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MessagePage(
                        title: 'Welcome to Childfree Connection!',
                        description: 'Ready to build your profile?',
                      ),
                      SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () {
                          goToPage(1);
                        },
                        child: Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  );
                if (index == 10)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MessagePage(
                        title: 'Welcome to Childfree Connection!',
                        description: 'Ready to build your profile?',
                      ),
                      SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () {
                          goToPage(1);
                        },
                        child: Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  );

                if (index == 1) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NamePage(
                        onNextPressed: (String name) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                goToPage(0);
                              },
                              child: Icon(Icons.keyboard_arrow_left),
                            ),
                            SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {
                                print('Going right');
                                goToPage(2);
                              },
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (index == 2)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfilePictureUpload(
                        onNextPressed: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                goToPage(1);
                              },
                              child: Icon(Icons.keyboard_arrow_left),
                            ),
                            SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {
                                goToPage(3);
                              },
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildQuestionWidget(_questions[index]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: previousPage,
                            child: Icon(Icons.keyboard_arrow_left),
                          ),
                          SizedBox(width: 4),
                          ElevatedButton(
                            onPressed: nextPage,
                            child: Icon(Icons.keyboard_arrow_right),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Navigate to Home Page
        print('Navigating to Home Page');
        goToPage(1);
        break;
      case 1:
        goToPage(6);

        // Navigate to Settings Page
        print('Setting States to Page 6');
        break;
      case 2:
        // Navigate to Profile Page
        print('Navigating to Profile Page');
        break;
      case 3:
        // Navigate to Messages Page
        print('Navigating to Messages Page');
        break;
      // Add more cases for additional pages
      default:
        break;
    }
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
