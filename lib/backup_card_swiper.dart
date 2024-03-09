import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Notifiers/all_users_notifier.dart';
import 'firebase_options.dart';

class CardView extends StatefulWidget {
  const CardView({Key? key}) : super(key: key);

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  @override
  Widget build(BuildContext context) {
    final allUsersNotifier = Provider.of<AllUsersNotifier>(context);

    List<Widget> cards = allUsersNotifier.profiles
        .where((profile) => profile['profilePicture'] != null)
        .map((profile) {
      return GestureDetector(
        onTap: () => print('Tapped'),
        child: Column(
          children: [
            Card(
              color: Colors.deepPurpleAccent,
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.transparent,
                      image: DecorationImage(
                        image:
                            NetworkImage(profile['profilePicture'] ?? 'Crigne'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16.0),
                              bottomRight: Radius.circular(16.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                profile['name'] as String,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '18 years old',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                profile['aboutMe'] ?? 'Crigne',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Column(
                      children: [
                        Card(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Text(
                                'Interests',
                                style: TextStyle(fontSize: 22),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: (profile['selectedInterests']
                                        as List<dynamic>)
                                    .map((interest) => Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Chip(label: Text(interest)),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'I am the perfect match because...',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ],
                              ),
                              profile['aboutMe'] != null &&
                                      profile['aboutMe'].isNotEmpty
                                  ? Text(
                                      profile['aboutMe'],
                                      style: TextStyle(fontSize: 20),
                                    )
                                  : Text('Nothing yet...')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .8,
            width: 1500,
            child: AppinioSwiper(
                loop: true,
                cardBuilder: (context, index) {
                  return cards[index];
                },
                cardCount: cards.length),
          ),
        ],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Sign in (if needed)
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: "dev@gmail.com", password: "testing");
  // Create the notifier and fetch profiles
  final allUsersNotifier = AllUsersNotifier();
  allUsersNotifier.fetchHardcodedProfiles();
  // Run the app
  runApp(MaterialApp(
    home: ChangeNotifierProvider(
      create: (context) => allUsersNotifier,
      child: CardView(),
    ),
    debugShowCheckedModeBanner: false,
  ));
}
