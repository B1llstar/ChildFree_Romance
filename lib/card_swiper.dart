import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:childfree_romance/Cards/user_card.dart';
import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:childfree_romance/Services/matchmaking_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:provider/provider.dart';

import 'Cards/user_card_web.dart';
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
  late AllUsersNotifier _allUsersNotifier;
  AppinioSwiperController _swiperController = AppinioSwiperController();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _allUsersNotifier = Provider.of<AllUsersNotifier>(context, listen: false);

    _flipCardController = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    _matchmakingService =
        Provider.of<MatchmakingNotifier>(context, listen: false);
    double? height;
    double? width;
    if (!kIsWeb) {
      width = MediaQuery.of(context).size.width < 500 ? 350 : 500;
      height = MediaQuery.of(context).size.height * 0.65;
    } else {
      width = MediaQuery.of(context).size.width < 500
          ? MediaQuery.of(context).size.width
          : 600;
      height = MediaQuery.of(context).size.height * 0.8;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: height,
              width: width,
              child: Consumer<MatchmakingNotifier>(
                  builder: (context, notifier, child) {
                return FutureBuilder(
                    future: _matchmakingService.init(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return SizedBox(
                          child: AppinioSwiper(
                            backgroundCardScale: .8,
                            controller: _swiperController,
                            loop: false,
                            onEnd: () {
                              print('We\'re all out of cards!');
                            },
                            onSwipeEnd: (int index, int direction,
                                SwiperActivity activity) {
                              if (activity.end!.dx > 0.0) {
                                print('Swiped right');
                                String swipedUserId =
                                    notifier.allMatches[index]['userId'];
                                _swipeService.makeSwipe(
                                    swipedUserId: swipedUserId,
                                    swipeType: 'standardYes');
                                notifier.addToPreviousSwipesList(
                                    notifier.allMatches[index]);
                              } else {
                                print('Swiped left');
                                String swipedUserId =
                                    notifier.allMatches[index]['userId'];
                                _swipeService.makeSwipe(
                                    swipedUserId: swipedUserId,
                                    swipeType: 'nope');
                                notifier.addToPreviousSwipesList(
                                    notifier.allMatches[index]);
                              }
                            },
                            onCardPositionChanged: (SwiperPosition position) {},
                            cardBuilder: (context, index) {
                              return !kIsWeb
                                  ? ProfileCard(
                                      profile: notifier.allMatches[index],
                                      flipCardController: _flipCardController,
                                    )
                                  : ProfileCardWeb(
                                      profile: notifier.allMatches[index],
                                      flipCardController: _flipCardController,
                                    );
                            },
                            cardCount: notifier.allMatches.length,
                            swipeOptions: SwipeOptions.only(
                              up: false,
                              down: false,
                              left: true,
                              right: true,
                            ),
                          ),
                        );
                      }
                    });
              }),
            ),
          ],
        ),
        SizedBox(
          height: 16,
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
