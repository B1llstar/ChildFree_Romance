import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:childfree_romance/Cards/user_card.dart';
import 'package:childfree_romance/Services/matchmaking_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:provider/provider.dart';

import 'Notifiers/all_users_notifier.dart';
import 'Services/swipe_service.dart';
import 'firebase_options.dart';

class CardView extends StatefulWidget {
  const CardView({Key? key}) : super(key: key);

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  final SwipeService _swipeService = SwipeService();
  late MatchmakingService _matchmakingService;
  late Future<List<Map<String, dynamic>>> _filteredProfilesFuture;
  late List<FlipCardController> _flipCardControllers = [];
  AppinioSwiperController _swiperController = AppinioSwiperController();
  @override
  void initState() {
    super.initState();
    _matchmakingService = MatchmakingService(
      FirebaseAuth.instance.currentUser!.uid,
      Provider.of<AllUsersNotifier>(context, listen: false),
    );
    _initializeFilteredProfilesFuture();
  }

  Future<void> _initializeFilteredProfilesFuture() async {
    await _matchmakingService.init();
    setState(() {
      _filteredProfilesFuture = Future.value(_matchmakingService.matches);
      _flipCardControllers = List.generate(
        _matchmakingService.matches.length,
        (index) => FlipCardController(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double? width;
    if (!kIsWeb)
      width = MediaQuery.of(context).size.width < 500 ? 650 : 600;
    else
      width = MediaQuery.of(context).size.width < 500
          ? MediaQuery.of(context).size.width
          : 600;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _filteredProfilesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> filteredProfiles = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: width,
                    child: AppinioSwiper(
                      controller: _swiperController,
                      loop: true,
                      onCardPositionChanged: (SwiperPosition position) {},
                      cardBuilder: (context, index) {
                        return ProfileCard(
                          profile: filteredProfiles[index],
                          flipCardController: _flipCardControllers[index],
                        );
                      },
                      cardCount: filteredProfiles.length,
                      swipeOptions: SwipeOptions.only(
                        up: false,
                        down: false,
                        left: true,
                        right: true,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width < 500
                    ? MediaQuery.of(context).size.width
                    : 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        _swiperController.swipeLeft();
                        // Functionality for red button
                        print('Red button clicked');
                      },
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        // Functionality for info button
                        print('Info button clicked');
                        // Flip the card
                        _flipCardControllers.forEach((controller) {
                          controller.flipcard();
                        });
                      },
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.info, color: Colors.white),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        _swiperController.swipeRight();
                        // Functionality for green button
                        print('Green button clicked');
                      },
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        }
      },
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
