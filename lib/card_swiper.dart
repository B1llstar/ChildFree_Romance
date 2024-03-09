import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Cards/user_card.dart';
import 'Notifiers/all_users_notifier.dart';
import 'Services/swipe_service.dart';
import 'firebase_options.dart';

class CardView extends StatefulWidget {
  const CardView({Key? key}) : super(key: key);

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  final SwipeService _matchmakingService = SwipeService();

  @override
  Widget build(BuildContext context) {
    final allUsersNotifier = Provider.of<AllUsersNotifier>(context);

    List<Widget> cards = allUsersNotifier.profiles
        .where((profile) => profile['profilePictures'] != null)
        .map((profile) {
      return GestureDetector(
        onTap: () => print('Tapped'),
        child: ProfileCard(profile: profile),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width < 500
              ? MediaQuery.of(context).size.width
              : 500,
          child: AppinioSwiper(
            loop: true,
            onSwipeEnd: (int index, int direction, SwiperActivity activity) {
              if (activity.end!.dx > 0.0) {
                print('Swiped right');
                String swipedUserId =
                    allUsersNotifier.profiles[index]['userId'];
                _matchmakingService.makeSwipe(
                  swipedUserId: swipedUserId,
                  swipeType: 'standardYes',
                );
              } else {
                print('Swiped left');
                String swipedUserId =
                    allUsersNotifier.profiles[index]['userId'];
                _matchmakingService.makeSwipe(
                  swipedUserId: swipedUserId,
                  swipeType: 'nope',
                );
              }
            },
            onCardPositionChanged: (SwiperPosition position) {},
            cardBuilder: (context, index) {
              return cards[index];
            },
            cardCount: cards.length,
            swipeOptions: SwipeOptions.only(
              up: false,
              down: false,
              left: true,
              right: true,
            ),
          ),
        ),
      ],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: "dev@gmail.com", password: "testing");

  final allUsersNotifier = AllUsersNotifier();
  allUsersNotifier.init(FirebaseAuth.instance.currentUser!.uid);

  runApp(MaterialApp(
    home: ChangeNotifierProvider(
      create: (context) => allUsersNotifier,
      child: CardView(),
    ),
    debugShowCheckedModeBanner: false,
  ));
}
