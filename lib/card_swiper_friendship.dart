import 'dart:async';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:childfree_romance/Cards/loadingWidget.dart';
import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:childfree_romance/Services/matchmaking_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:provider/provider.dart';

import 'Cards/user_card_web.dart';
import 'Screens/Settings/Tiles/settings_service.dart';
import 'Services/swipe_service.dart';

class CardViewFriendship extends StatefulWidget {
  const CardViewFriendship({Key? key}) : super(key: key);

  @override
  State<CardViewFriendship> createState() => _CardViewFriendshipState();
}

class _CardViewFriendshipState extends State<CardViewFriendship> {
  final SwipeService _swipeService = SwipeService();
  late MatchmakingNotifier _matchmakingService;
  late FlipCardController _flipCardController;
  late AllUsersNotifier _allUsersNotifier;
  AppinioSwiperController _swiperController = AppinioSwiperController();
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0; // Track the current index
  String glowType = 'none';
  bool _isButtonDisabled = false; // Boolean flag to control button clicks
  late Timer _debounceTimer; // Timer for debouncing button clicks
  @override
  void initState() {
    super.initState();
    _flipCardController = FlipCardController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      loadData();
    });
    Provider.of<MatchService>(context, listen: false).refresh();
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
    });
    while (Provider.of<MatchService>(context, listen: false)
        .friendshipMatches
        .isEmpty) {
      await Future.delayed(Duration(seconds: 1));
    }
    await Provider.of<MatchService>(context, listen: false)
        .getProfilePictures(context);

    setState(() {
      isLoading = false;
    });
  }

  // Callback function to scroll to the top of ProfileCardWeb
  void scrollBackUp() {
    _scrollController.jumpTo(0);
  }

  // Method to debounce button clicks
  void _debounceButton() {
    setState(() {
      _isButtonDisabled = true; // Disable the buttons
    });
    _debounceTimer = Timer(Duration(seconds: 2), () {
      // Enable the buttons after 3 seconds
      setState(() {
        _isButtonDisabled = false;
      });
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

        return Stack(
          fit: StackFit.expand,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: SizedBox(
                    height: height ?? 0,
                    width: width ?? 0,
                    child: matchService.friendshipMatches != null &&
                            matchService.friendshipMatches.isNotEmpty
                        ? isLoading
                            ? SizedBox(
                                height: 50,
                                width: 50,
                                child: CFCLoadingWidget())
                            : Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: matchService.glowType == 'Yes'
                                        ? Colors.green
                                        : matchService.glowType == 'No'
                                            ? Colors.red
                                            : Colors
                                                .transparent, // Set transparent color when glowType is 'None'
                                  )
                                ]),
                                child: AppinioSwiper(
                                  isDisabled: false,
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
                                      if (index <
                                          matchService
                                              .friendshipMatches.length) {
                                        String swipedUserId = matchService
                                            .friendshipMatches[index]['userId'];
                                        _swipeService.makeSwipe(
                                            swipedUserId: swipedUserId,
                                            swipeType: 'standardYes',
                                            isRomance: false);
                                      }
                                    } else {
                                      print('Swiped left');
                                      if (index <
                                          matchService
                                              .friendshipMatches.length) {
                                        String swipedUserId = matchService
                                            .friendshipMatches[index]['userId'];
                                        _swipeService.makeSwipe(
                                            swipedUserId: swipedUserId,
                                            swipeType: 'nope',
                                            isRomance: false);
                                      }
                                    }
                                    _currentIndex =
                                        index; // Update current index
                                    scrollBackUp();
                                    print('Done swiping');
                                    matchService.glowType = 'None';
                                  },
                                  onCardPositionChanged:
                                      (SwiperPosition position) {
                                    print('Changing position');
                                    print(position.offset.dx);
                                    if (position.offset.dx > 0) {
                                      print('Moving right....');
                                      setState(() {
                                        matchService.glowType = 'Yes';
                                        print('Setting glow type...');
                                      });
                                    } else if (position.offset.dx < 0) {
                                      print('Moving left....');
                                      matchService.glowType = 'No';
                                    } else {
                                      print('Stationary');
                                    }
                                  },
                                  cardBuilder: (context, index) {
                                    if (index <
                                        matchService.friendshipMatches.length) {
                                      return !kIsWeb
                                          ? ProfileCardWeb(
                                              profile: matchService
                                                  .friendshipMatches[index],
                                              scrollController:
                                                  _scrollController,
                                            )
                                          : ProfileCardWeb(
                                              profile: matchService
                                                  .friendshipMatches[index],
                                              scrollController:
                                                  _scrollController,
                                            );
                                    } else {
                                      return SizedBox(); // Return an empty SizedBox if index is out of bounds
                                    }
                                  },
                                  cardCount:
                                      matchService.friendshipMatches.length,
                                  swipeOptions: SwipeOptions.only(
                                    up: false,
                                    down: false,
                                    left: true,
                                    right: true,
                                  ),
                                ),
                              )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/cfc_logo_med_2.png'),
                                SizedBox(height: 2),
                                Text(
                                    'Thanks for participating in the Closed Beta!',
                                    style: TextStyle(
                                        color: _allUsersNotifier.darkMode
                                            ? Colors.white
                                            : Colors.black)),
                                Text('Check back soon for more matches!',
                                    style: TextStyle(
                                        color: _allUsersNotifier.darkMode
                                            ? Colors.white
                                            : Colors.black)),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: _isButtonDisabled
                          ? null
                          : () {
                              if (_currentIndex ==
                                  matchService.friendshipMatches.length - 1) {
                                print('Can\'t swipe any further!');
                                return;
                              }
                              //       _debounceButton();
                              _swiperController.swipeLeft();

                              /*
                        String swipedUserId =
                            matchService.friendshipMatches[_currentIndex]
                                ['userId']; // Use current index
                        _swipeService.makeSwipe(
                            swipedUserId: swipedUserId,
                            swipeType:
                                'nope'); // Call makeSwipe with appropriate index

                         */
                              scrollBackUp();
                              print('Red button clicked');
                            },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white, elevation: 6),
                      child: Icon(Icons.close, color: Colors.black, size: 40),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: _isButtonDisabled
                        ? null
                        : () {
                            if (_currentIndex ==
                                matchService.friendshipMatches.length - 1) {
                              print('Can\'t swipe any further!');
                              return;
                            }
                            //    _debounceButton();
                            _swiperController.swipeRight();
                            /*
                      String swipedUserId =
                          matchService.friendshipMatches[_currentIndex]
                              ['userId']; // Use current index
                      _swipeService.makeSwipe(
                          swipedUserId: swipedUserId,
                          swipeType:
                              'standardYes'); // Call makeSwipe with appropriate index

                       */
                            scrollBackUp();
                            print('Green button clicked');
                          },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 6,
                    ),
                    child: Icon(Icons.check, color: Colors.black, size: 40),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
