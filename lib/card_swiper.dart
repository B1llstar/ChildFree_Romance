import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:childfree_romance/Cards/user_card.dart';
import 'package:childfree_romance/Services/matchmaking_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:provider/provider.dart';

import 'Services/swipe_service.dart';

class CardView extends StatefulWidget {
  const CardView({Key? key}) : super(key: key);

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  final SwipeService _swipeService = SwipeService();
  late MatchmakingNotifier _matchmakingService;
  late FlipCardController _flipCardController;
  AppinioSwiperController _swiperController = AppinioSwiperController();

  @override
  void initState() {
    super.initState();
    _matchmakingService =
        Provider.of<MatchmakingNotifier>(context, listen: false);
    _flipCardController = FlipCardController();
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
                loop: false,
                onEnd: () {
                  print('We\'re all out of cards!');
                },
                onSwipeEnd:
                    (int index, int direction, SwiperActivity activity) {
                  if (activity.end!.dx > 0.0) {
                    print('Swiped right');
                    String swipedUserId =
                        _matchmakingService.allMatches[index]['userId'];
                    _swipeService.makeSwipe(
                        swipedUserId: swipedUserId, swipeType: 'standardYes');
                    _matchmakingService.addToPreviousSwipesList(
                        _matchmakingService.allMatches[index]);
                  } else {
                    print('Swiped left');
                    String swipedUserId =
                        _matchmakingService.allMatches[index]['userId'];
                    _swipeService.makeSwipe(
                        swipedUserId: swipedUserId, swipeType: 'nope');
                    _matchmakingService.addToPreviousSwipesList(
                        _matchmakingService.allMatches[index]);
                  }
                },
                onCardPositionChanged: (SwiperPosition position) {},
                cardBuilder: (context, index) {
                  return ProfileCard(
                    profile: _matchmakingService.allMatches[index],
                    flipCardController: _flipCardController,
                  );
                },
                cardCount: _matchmakingService.allMatches.length,
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
                  print('Red button clicked');
                },
                backgroundColor: Colors.red,
                child: Icon(Icons.close, color: Colors.white),
              ),
              FloatingActionButton(
                onPressed: () {
                  print('Info button clicked');
                  _flipCardController.flipcard();
                },
                backgroundColor: Colors.blue,
                child: Icon(Icons.info, color: Colors.white),
              ),
              FloatingActionButton(
                onPressed: () {
                  _swiperController.swipeRight();
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
}
