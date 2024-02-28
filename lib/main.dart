import 'package:childfree_romance/Screens/EasyIntro/describe_yourself.dart';
import 'package:childfree_romance/Screens/EasyIntro/feedback_page.dart';
import 'package:childfree_romance/Screens/EasyIntro/newsletter_signup_page.dart';
import 'package:childfree_romance/Screens/EasyIntro/question.dart';
import 'package:childfree_romance/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:provider/provider.dart';

import 'Auth/login.dart';
import 'Notifiers/user_notifier.dart';
import 'Screens/EasyIntro/closing_page.dart';
import 'Screens/EasyIntro/dream_partner.dart';
import 'Screens/EasyIntro/message_page_only.dart';
import 'Screens/EasyIntro/name_page.dart';
import 'Screens/User/upload_profile_picture.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: "dev@gmail.com", password: "testing");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        // Add more providers if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  PageController? _pageController;
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _aboutMeTextEditingController = TextEditingController();
  TextEditingController _myDreamPartnerTextEditingController =
      TextEditingController();
  TextEditingController _feedbackController = TextEditingController();
  int currentPageIndex = 0;
  UserDataProvider? _userDataNotifier;

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
      print('trying to go to next page');
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

  void onNewsletterButtonPressed() {
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

  // Goal: Sync up questions with indices of items in the page
  // Use placeholders when needed so the length amtchse up

  // ANYTHING BUT THE FIRST AND LAST INDICES WITH A PLACEHOLDER
  // IS DEFINED IN THE PAGE CONTROLLER AREA ITSELF
  List<Map<String, dynamic>> _questions = [
    {
      'property': 'does420',
      'title': 'WELCOME',
      'options': [],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'NAME',
      'title': 'Placeholder',
      'options': [],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'interests',
      'title': 'What are your interests?',
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
    {
      'property': 'PROFILE PICTURE',
      'title': 'Placeholder',
      'options': [],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'isSterilized',
      'title': 'Are you sterilized?',
      'options': ['Yes', 'No', 'Eventually'],
      'assetImageUrl': 'assets/stethoscope.png',
    },
    {
      'property': 'isLookingFor',
      'title': 'What are you looking for?',
      'options': ['Romance', 'Friendship', 'Anything'],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'willDoLongDistance',
      'title': 'Are you open to long-distance?',
      'options': ['Yes', 'No'],
      'assetImageUrl': 'assets/globe.png',
    },
    {
      'property': 'willRelocate',
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
      'property': 'DESCRIBE YOUR PERFECT MATCH',
      'title': 'Placeholder',
      'options': [],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'I AM THE PERFECT MATCH BECAUSE',
      'title': 'Placeholder',
      'options': [],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'NEWSLETTER',
      'title': 'Placeholder',
      'options': [],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'FEEDBACK',
      'title': 'Placeholder',
      'options': [],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'CLOSING',
      'title': 'Placeholder',
      'options': [],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_userDataNotifier == null)
      _userDataNotifier = Provider.of<UserDataProvider>(context, listen: false);
    final List<String> pageTitles = [
      'Basics',
      'Vices',
      'Preferences',
      'Interests'
    ];

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
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
              itemCount: _questions.length + 7, // Corrected item count
              itemBuilder: (context, index) {
                if (index == 15) {
                  // Adjusted index
                  return ClosingPage();
                } else if (index == 0)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MessagePage(
                        title: 'Childfree Connection',
                        description: 'Ready to build your profile?',
                      ),
                      SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () {
                          goToPage(index + 1);
                        },
                        child: Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  );
                else if (index == 2)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildQuestionWidget(_questions[2], index),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              goToPage(index - 1);
                            },
                            child: Icon(Icons.keyboard_arrow_left),
                          ),
                          SizedBox(width: 4),
                          ElevatedButton(
                            onPressed: () {
                              goToPage(index + 1);
                              UserDataProvider userDataProvider =
                                  Provider.of<UserDataProvider>(context,
                                      listen: false);
                              userDataProvider
                                  .updateSelectedInterestsInFirestore();
                            },
                            child: Icon(Icons.keyboard_arrow_right),
                          ),
                        ],
                      ),
                    ],
                  );
                else if (index == 11)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DreamPartnerPage(
                          controller: _myDreamPartnerTextEditingController),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                goToPage(index - 1);
                              },
                              child: Icon(Icons.keyboard_arrow_left),
                            ),
                            SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {
                                if (_myDreamPartnerTextEditingController.text !=
                                        null &&
                                    _myDreamPartnerTextEditingController
                                        .text.isNotEmpty) {
                                  print('Length of controller text: ' +
                                      _myDreamPartnerTextEditingController
                                          .text.length
                                          .toString());
                                  updatePropertyInFirestore(
                                      'dreamPartner',
                                      _myDreamPartnerTextEditingController
                                          .text);
                                }
                                print('Going right');
                                goToPage(index + 1);
                              },
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                else if (index == 13)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NewsletterPage(
                          onNewsletterButtonPressed: onNewsletterButtonPressed),
                      SizedBox(width: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              goToPage(index - 1);
                            },
                            child: Icon(Icons.keyboard_arrow_left),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              goToPage(index + 1);
                            },
                            child: Icon(Icons.keyboard_arrow_right),
                          ),
                        ],
                      ),
                    ],
                  );
                else if (index == 14)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FeedbackPage(controller: _feedbackController),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                goToPage(index - 1);
                              },
                              child: Icon(Icons.keyboard_arrow_left),
                            ),
                            SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {
                                if (_feedbackController.text != null &&
                                    _feedbackController.text.isNotEmpty) {
                                  print('Length of controller text: ' +
                                      _feedbackController.text.length
                                          .toString());
                                  updatePropertyInFirestore(
                                      'feedback', _feedbackController.text);
                                }
                                print('Going right');
                                goToPage(index + 1);
                              },
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                else if (index == 12)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DescribeYourselfPage(
                          controller: _aboutMeTextEditingController),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                goToPage(index - 1);
                              },
                              child: Icon(Icons.keyboard_arrow_left),
                            ),
                            SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {
                                if (_aboutMeTextEditingController.text !=
                                        null &&
                                    _aboutMeTextEditingController
                                        .text.isNotEmpty) {
                                  print('Length of controller text: ' +
                                      _aboutMeTextEditingController.text.length
                                          .toString());
                                  updatePropertyInFirestore('aboutMe',
                                      _aboutMeTextEditingController.text);
                                }
                                print('Going right');
                                goToPage(index + 1);
                              },
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                else if (index == 1) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NamePage(
                          controller: _textEditingController,
                          userDataNotifier: _userDataNotifier!),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                goToPage(index - 1);
                              },
                              child: Icon(Icons.keyboard_arrow_left),
                            ),
                            SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {
                                if (_textEditingController.text != null &&
                                    _textEditingController.text.isNotEmpty) {
                                  print('Length of controller text: ' +
                                      _textEditingController.text.length
                                          .toString());
                                  updatePropertyInFirestore(
                                      'name', _textEditingController.text);
                                }
                                print('Going right');
                                goToPage(index + 1);
                              },
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (index == 3)
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
                                goToPage(index - 1);
                              },
                              child: Icon(Icons.keyboard_arrow_left),
                            ),
                            SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {
                                goToPage(index + 1);
                              },
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );

                // At index 5, return _question item at index
                else
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildQuestionWidget(_questions[index], index),
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

  Widget _buildQuestionWidget(Map<String, dynamic> question, int index) {
    return QuestionWidget(
      property: question['property'],
      title: question['title'],
      assetImageUrl: question['assetImageUrl'],
      options: question['options'],
      onButtonPressed: onButtonPressed,
      index: index,
    );
  }
}
