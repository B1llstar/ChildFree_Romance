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
  bool doneSwiping = false;
  late AllUsersNotifier _allUsersNotifier;
  AppinioSwiperController _swiperController = AppinioSwiperController();
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  List<AppinioSwiperController> _swiperControllers = [
    AppinioSwiperController()
  ];
  int _currentIndex = 0; // Track the current index
  int swipeControllerIndex = 0;
  String glowType = 'none';
  bool _isButtonDisabled = false; // Boolean flag to control button clicks
  late Timer _debounceTimer; // Timer for debouncing button clicks
  @override
  void initState() {
    super.initState();
    _flipCardController = FlipCardController();
    Provider.of<MatchService>(context, listen: false).refresh();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
      print('Setting isLoading to true');
    });
    while (Provider.of<MatchService>(context, listen: false)
        .friendshipMatches
        .isEmpty) {
      await Future.delayed(Duration(seconds: 1));
    }

    setState(() {
      isLoading = false;
      print('Is loading is false');
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          if (doneSwiping) // Show the "Refresh" button when swiping is done
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await matchService
                                                        .refreshAllNopeSwipesForRelationshipType(
                                                            'Romance');
                                                    _swiperControllers.add(
                                                        AppinioSwiperController());
                                                    swipeControllerIndex++;
                                                    await matchService
                                                        .refresh();
                                                    setState(() {
                                                      _currentIndex =
                                                          0; // Reset the current index
                                                      doneSwiping =
                                                          false; // Reset the swiping flag
                                                    });
                                                  },
                                                  child: Text(
                                                      'Refresh (show old left swipes)'),
                                                ),
                                              ],
                                            ),
                                          if (!doneSwiping)
                                            AppinioSwiper(
                                              isDisabled: false,
                                              backgroundCardCount: 0,
                                              backgroundCardScale: .8,
                                              controller: _swiperControllers[
                                                  swipeControllerIndex],
                                              threshold: 200,
                                              loop: false,
                                              onEnd: () {
                                                print(
                                                    'We\'re all out of cards!');
                                                setState(() {
                                                  doneSwiping = true;
                                                });
                                              },
                                              onSwipeBegin: (int index,
                                                  int direction,
                                                  SwiperActivity activity) {
                                                setState(() {
                                                  _currentIndex = index;
                                                });
                                              },
                                              onSwipeEnd: (int index,
                                                  int direction,
                                                  SwiperActivity activity) {
                                                if (activity.end!.dx > 0.0) {
                                                  print('Swiped right');
                                                  print(
                                                      'WE SWIPED OR SOMETHING');
                                                  if (index <
                                                      matchService
                                                          .friendshipMatches
                                                          .length) {
                                                    String swipedUserId =
                                                        matchService
                                                                .friendshipMatches[
                                                            index]['userId'];
                                                    _swipeService.makeSwipe(
                                                        swipedUserId:
                                                            swipedUserId,
                                                        swipeType:
                                                            'standardYes',
                                                        isRomance: true);
                                                    setState(() {
                                                      _currentIndex = index + 1;
                                                    });
                                                    if (_currentIndex ==
                                                        matchService
                                                            .friendshipMatches
                                                            .length) {
                                                      print('Done!');
                                                    }
                                                  }
                                                  matchService.glowType =
                                                      'None';
                                                } else {
                                                  print('Swiped left');
                                                  if (index <
                                                      matchService
                                                          .friendshipMatches
                                                          .length) {
                                                    String swipedUserId =
                                                        matchService.friendshipMatches[
                                                                    index]
                                                                ['userId'] ??
                                                            '123';
                                                    _swipeService.makeSwipe(
                                                        swipedUserId:
                                                            swipedUserId,
                                                        swipeType: 'nope',
                                                        isRomance: true);
                                                    setState(() {
                                                      _currentIndex = index + 1;
                                                    });
                                                  }
                                                  if (_currentIndex ==
                                                      matchService
                                                          .friendshipMatches
                                                          .length) {
                                                    print('Done!');
                                                  }
                                                  matchService.glowType =
                                                      'None';
                                                }

                                                scrollBackUp();
                                                print('Done swiping');
                                              },
                                              onCardPositionChanged:
                                                  (SwiperPosition position) {
                                                print('Changing position');
                                                print(position.offset.dx);
                                                if (position.offset.dx > 0) {
                                                  print('Moving right....');
                                                  setState(() {
                                                    matchService.glowType =
                                                        'Yes';
                                                    print(
                                                        'Setting glow type...');
                                                  });
                                                } else if (position.offset.dx <
                                                    0) {
                                                  print('Moving left....');
                                                  matchService.glowType = 'No';
                                                } else {
                                                  print('Stationary');
                                                }
                                              },
                                              cardBuilder: (context, index) {
                                                if (index <
                                                    matchService
                                                        .friendshipMatches
                                                        .length) {
                                                  bool isTopCard =
                                                      index == _currentIndex;
                                                  bool isSwipedLeft =
                                                      matchService.glowType ==
                                                          'No';
                                                  bool isSwipedRight =
                                                      matchService.glowType ==
                                                          'Yes';

                                                  return Stack(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                ProfileCardWeb(
                                                              profile: matchService
                                                                      .friendshipMatches[
                                                                  index],
                                                              scrollController:
                                                                  _scrollController,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (isSwipedLeft &&
                                                          isTopCard)
                                                        Positioned(
                                                          top: 25,
                                                          left: 25,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 4),
                                                            ),
                                                            child: Text('NOPE',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        48,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ),
                                                      if (isSwipedRight &&
                                                          isTopCard)
                                                        Positioned(
                                                          top: 25,
                                                          right: 25,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .green,
                                                                  width: 4),
                                                            ),
                                                            child: Text('LIKE',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        48,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                } else {
                                                  return SizedBox(); // Return an empty SizedBox if index is out of bounds
                                                }
                                              },
                                              cardCount: matchService
                                                  .friendshipMatches.length,
                                              swipeOptions: SwipeOptions.only(
                                                up: false,
                                                down: false,
                                                left: true,
                                                right: true,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: kIsWeb ? 50 : 8),
                                    SizedBox(
                                      height: 100,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: ElevatedButton(
                                              onPressed: _isButtonDisabled
                                                  ? null
                                                  : () {
                                                      if (_currentIndex ==
                                                              matchService
                                                                      .friendshipMatches
                                                                      .length -
                                                                  1 &&
                                                          _currentIndex != 0) {
                                                        print(
                                                            'Can\'t swipe any further!');
                                                        return;
                                                      }
                                                      // _debounceButton();
                                                      _swiperControllers[
                                                              swipeControllerIndex]
                                                          .swipeLeft();

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
                                                      print(
                                                          'Red button clicked');
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  elevation: 6),
                                              child: Icon(Icons.close,
                                                  color: Colors.black,
                                                  size: 40),
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
                                                            matchService
                                                                    .friendshipMatches
                                                                    .length -
                                                                1 &&
                                                        _currentIndex != 0) {
                                                      print(
                                                          'Can\'t swipe any further!');
                                                      return;
                                                    }
                                                    //_debounceButton();
                                                    _swiperControllers[
                                                            swipeControllerIndex]
                                                        .swipeRight();
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
                                                    print(
                                                        'Green button clicked');
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              elevation: 6,
                                            ),
                                            child: Icon(Icons.check,
                                                color: Colors.black, size: 40),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        : Center(
                            child: Consumer<AllUsersNotifier>(
                              builder: (context, _allUsersNotifier, _) =>
                                  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/cfc_logo_med_2.png'),
                                  SizedBox(height: 2),
                                  Text(
                                    'Thanks for participating in the Closed Beta!',
                                    style: TextStyle(
                                      color: _allUsersNotifier.darkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Check back soon for more profiles!',
                                    style: TextStyle(
                                      color: _allUsersNotifier.darkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  if (matchService.totalNopeSwipes >
                                      0) // Show the "Refresh" button when swiping is done
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            await matchService
                                                .refreshAllNopeSwipesForRelationshipType(
                                                    'Romance');
                                            _swiperControllers
                                                .add(AppinioSwiperController());
                                            swipeControllerIndex++;
                                            await matchService.refresh();
                                            setState(() {
                                              _currentIndex =
                                                  0; // Reset the current index
                                              doneSwiping =
                                                  false; // Reset the swiping flag
                                            });
                                          },
                                          child: Text(
                                              'Refresh (show old left swipes)'),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
