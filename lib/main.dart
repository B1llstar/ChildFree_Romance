import 'package:childfree_romance/Auth/login.dart';
import 'package:childfree_romance/Screens/EasyIntro/describe_yourself.dart';
import 'package:childfree_romance/Screens/EasyIntro/dob_page.dart';
import 'package:childfree_romance/Screens/EasyIntro/feedback_page.dart';
import 'package:childfree_romance/Screens/EasyIntro/newsletter_signup_page.dart';
import 'package:childfree_romance/Screens/EasyIntro/question.dart';
import 'package:childfree_romance/Screens/EasyIntro/solemnly_swear_page.dart';
import 'package:childfree_romance/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Notifiers/all_users_notifier.dart';
import 'Notifiers/user_notifier.dart';
import 'Screens/EasyIntro/closing_page.dart';
import 'Screens/EasyIntro/country_picker_page.dart';
import 'Screens/EasyIntro/dream_partner.dart';
import 'Screens/EasyIntro/message_page_only.dart';
import 'Screens/EasyIntro/name_page.dart';
import 'Screens/User/upload_profile_picture.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final AllUsersNotifier allUsersNotifier = AllUsersNotifier();
  allUsersNotifier.fetchProfiles();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => allUsersNotifier),
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
      title: 'Childfree Connection',
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
  bool shouldShowNameNextButton = false;
  bool shouldShowDreamPartnerNextButton = false;
  bool shouldShowNewsletterNextButton = false;
  bool shouldShowInterestsNextButton = false;
  bool shouldShowDescribeYourselfNextButton = false;
  bool shouldShowCountryPickerButton = false;
  bool shouldShowSolemnlySwornNextButton = false;
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
        _userDataNotifier!.setVisitedPageAtIndex(currentPageIndex, 1);
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
      'property': 'DOB',
      'title': 'Placeholder',
      'options': [],
      'assetImageUrl': 'assets/magnifying_glass.png',
    },
    {
      'property': 'COUNTRY',
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
      'property': 'genderToShow',
      'title': 'Which would you like to see?',
      'options': ['Male', 'Female', 'Any'],
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
      'property': 'SOLEMNLY SWEAR',
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

    return Consumer(
        builder: (context, UserDataProvider userDataProvider, child) {
      return Scaffold(
        backgroundColor: Colors.deepPurpleAccent,
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _questions.length, // Corrected item count
                itemBuilder: (context, index) {
                  if (index == 19) {
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
                        DOBPage(),
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
                              onPressed: userDataProvider.dateOfBirth != null
                                  ? () {
                                      goToPage(index + 1);
                                    }
                                  : null,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ],
                    );
                  // Interests
                  else if (index == 4)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildQuestionWidget(_questions[4], index),
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
                                UserDataProvider userDataProvider =
                                    Provider.of<UserDataProvider>(context,
                                        listen: false);
                                if (userDataProvider
                                        .selectedInterests!.length ==
                                    0) {
                                  print('No interests detected');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Pick at least one interest')),
                                  );
                                  return;
                                }
                                userDataProvider
                                    .updateSelectedInterestsInFirestore();
                                print('Selected itnerests' +
                                    userDataProvider.selectedInterests
                                        .toString());
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
                        DreamPartnerPage(
                            controller: _myDreamPartnerTextEditingController,
                            onChanged: (value) {
                              if (value != null && value.isNotEmpty) {
                                setState(() {
                                  shouldShowDreamPartnerNextButton = true;
                                });
                              } else {
                                setState(() {
                                  shouldShowDreamPartnerNextButton = false;
                                });
                              }
                            }),
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
                                onPressed: _myDreamPartnerTextEditingController
                                            .text.length >
                                        0
                                    ? () {
                                        if (_myDreamPartnerTextEditingController
                                                    .text !=
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
                                      }
                                    : null,
                                child: Icon(Icons.keyboard_arrow_right),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  else if (index == 16)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NewsletterPage(onNewsletterButtonPressed: () {
                          setState(() {
                            print('Pressed a button');
                            shouldShowNewsletterNextButton = true;
                          });
                        }),
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
                              onPressed: shouldShowNewsletterNextButton
                                  ? () {
                                      goToPage(index + 1);
                                    }
                                  : null,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ],
                    );
                  else if (index == 3)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CountryPickerPage(onCountryPicked: (value) {
                          setState(() {
                            shouldShowCountryPickerButton = true;
                          });
                          updatePropertyInFirestore('country', value);
                          // Update Firestore Here
                        }),
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
                              onPressed: shouldShowCountryPickerButton
                                  ? () {
                                      goToPage(index + 1);
                                    }
                                  : null,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ],
                    );
                  else if (index == 18)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SolemnlySwearPage(onChecked: (value) {
                          if (value) {
                            setState(() {
                              shouldShowSolemnlySwornNextButton = true;
                            });
                          } else {
                            setState(() {
                              shouldShowSolemnlySwornNextButton = false;
                            });
                          }
                        }),
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
                                onPressed: !shouldShowSolemnlySwornNextButton
                                    ? null
                                    : () {
                                        goToPage(index + 1);
                                      },
                                child: Icon(Icons.keyboard_arrow_right),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  else if (index == 17)
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
                  else if (index == 15)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DescribeYourselfPage(
                            onChanged: (value) {
                              if (value.length == 0) {
                                setState(() {
                                  shouldShowDescribeYourselfNextButton = false;
                                });
                              } else {
                                setState(() {
                                  shouldShowDescribeYourselfNextButton = true;
                                });
                              }
                            },
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
                                onPressed: shouldShowDescribeYourselfNextButton
                                    ? () {
                                        if (_aboutMeTextEditingController
                                                    .text !=
                                                null &&
                                            _aboutMeTextEditingController
                                                .text.isNotEmpty) {
                                          print('Length of controller text: ' +
                                              _aboutMeTextEditingController
                                                  .text.length
                                                  .toString());
                                          updatePropertyInFirestore(
                                              'aboutMe',
                                              _aboutMeTextEditingController
                                                  .text);
                                        }
                                        print('Going right');
                                        goToPage(index + 1);
                                      }
                                    : null,
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
                            userDataNotifier: _userDataNotifier!,
                            onChanged: (value) {
                              if (value.length == 0) {
                                print('Changed to 0');
                                setState(() {
                                  shouldShowNameNextButton = false;
                                });
                              } else {
                                print('Changed to length > 0');
                                setState(() {
                                  shouldShowNameNextButton = true;
                                });
                              }
                            }),
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
                                onPressed: shouldShowNameNextButton
                                    ? () {
                                        if (_textEditingController.text !=
                                                null &&
                                            _textEditingController
                                                .text.isNotEmpty) {
                                          print('Length of controller text: ' +
                                              _textEditingController.text.length
                                                  .toString());
                                          updatePropertyInFirestore('name',
                                              _textEditingController.text);
                                        }
                                        print('Going right');
                                        goToPage(index + 1);
                                      }
                                    : null,
                                child: Icon(Icons.keyboard_arrow_right),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (index == 5)
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
    });
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

  void checkIfItemsListIsEmpty(List<String> items) {
    print('Checking list of items: ' + items.toString());
    if (items.isEmpty) {
      shouldShowInterestsNextButton = false;
    } else {
      shouldShowInterestsNextButton = true;
    }
  }

  Widget _buildQuestionWidget(Map<String, dynamic> question, int index) {
    return QuestionWidget(
      onItemsSelected: checkIfItemsListIsEmpty,
      property: question['property'],
      title: question['title'],
      assetImageUrl: question['assetImageUrl'],
      options: question['options'],
      onButtonPressed: onButtonPressed,
      index: index,
    );
  }
}
