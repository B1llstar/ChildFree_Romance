import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:childfree_romance/Services/matchmaking_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:provider/provider.dart';

import 'Cards/user_card_web.dart';
import 'Screens/Settings/Tiles/settings_service.dart';
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
    _flipCardController = FlipCardController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
    });
    while (Provider.of<MatchService>(context, listen: false)
        .romanceMatches
        .isEmpty) {
      await Future.delayed(Duration(seconds: 1));
    }
    await Provider.of<MatchService>(context, listen: false)
        .getProfilePictures(context);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchService>(
      builder: (context, matchService, _) {
        _matchmakingService =
            Provider.of<MatchmakingNotifier>(context, listen: false);
        _allUsersNotifier =
            Provider.of<AllUsersNotifier>(context, listen: false);

        double? height;
        double? width;
        if (!kIsWeb) {
          width = MediaQuery.of(context).size.width < 500 ? 350 : 500;
          height = MediaQuery.of(context).size.height * 1;
        } else {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          width = screenWidth < 500 ? screenWidth : 600;
          height = screenHeight * 0.8;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: SizedBox(
                    height: height ?? 0,
                    width: width ?? 0,
                    child: matchService.romanceMatches != null
                        ? isLoading
                            ? CircularProgressIndicator()
                            : AppinioSwiper(
                                isDisabled: true,
                                backgroundCardCount: 0,
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
                                    String swipedUserId = matchService
                                        .romanceMatches[index]['userId'];
                                    _swipeService.makeSwipe(
                                        swipedUserId: swipedUserId,
                                        swipeType: 'standardYes');
                                  } else {
                                    print('Swiped left');
                                    String swipedUserId = matchService
                                        .romanceMatches[index]['userId'];
                                    _swipeService.makeSwipe(
                                        swipedUserId: swipedUserId,
                                        swipeType: 'nope');
                                  }
                                },
                                onCardPositionChanged:
                                    (SwiperPosition position) {},
                                cardBuilder: (context, index) {
                                  if (matchService.romanceMatches == null ||
                                      matchService.romanceMatches.isEmpty) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return !kIsWeb
                                        ? ProfileCardWeb(
                                            profile: matchService
                                                .romanceMatches[index],
                                          )
                                        : ProfileCardWeb(
                                            profile: matchService
                                                .romanceMatches[index],
                                          );
                                  }
                                },
                                cardCount: 35,
                                swipeOptions: SwipeOptions.only(
                                  up: false,
                                  down: false,
                                  left: true,
                                  right: true,
                                ),
                              )
                        : Center(child: CircularProgressIndicator()),
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
                  Container(
                    width: 50,
                    child: FloatingActionButton(
                      onPressed: () {
                        _swiperController.swipeLeft();
                        print('Red button clicked');
                      },
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, color: Colors.black, size: 40),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _swiperController.swipeRight();
                      print('Green button clicked');
                    },
                    backgroundColor: Colors.white,
                    child: Icon(Icons.check, color: Colors.black, size: 40),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
