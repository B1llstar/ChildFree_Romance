import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Cards/user_card.dart';
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
    print(allUsersNotifier.profiles.length);
    List<Widget> cards = allUsersNotifier.profiles
        .where((profile) => profile['profilePictures'] != null)
        .map((profile) {
      return GestureDetector(
          onTap: () => print('Tapped'),
          child: ProfileCard(
            profile: profile,
          ));
    }).toList();

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 1,
// The width should be set to the width of the screen, until it caps at 500
            width: MediaQuery.of(context).size.width < 500
                ? MediaQuery.of(context).size.width
                : 500,

            child: AppinioSwiper(
              loop: true,
              cardBuilder: (context, index) {
                return cards[index];
              },
              cardCount: cards.length,
            ),
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
