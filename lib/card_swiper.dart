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
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0; // Track the current index
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
                    child: matchService.romanceMatches != null &&
                            matchService.romanceMatches.isNotEmpty
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
                                  threshold: 200,
                                  loop: false,
                                  onEnd: () {
                                    print('We\'re all out of cards!');
                                  },
                                  onSwipeEnd: (int index, int direction,
                                      SwiperActivity activity) {
                                    if (activity.end!.dx > 0.0) {
                                      print('Swiped right');
                                      print('WE SWIPED OR SOMETHING');
                                      if (index <
                                          matchService.romanceMatches.length) {
                                        String swipedUserId = matchService
                                            .romanceMatches[index]['userId'];
                                        _swipeService.makeSwipe(
                                            swipedUserId: swipedUserId,
                                            swipeType: 'standardYes',
                                            isRomance: true);
                                      }
                                    } else {
                                      print('Swiped left');
                                      if (index <
                                          matchService.romanceMatches.length) {
                                        String swipedUserId =
                                            matchService.romanceMatches[index]
                                                    ['userId'] ??
                                                '123';
                                        _swipeService.makeSwipe(
                                            swipedUserId: swipedUserId,
                                            swipeType: 'nope',
                                            isRomance: true);
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
                                        matchService.romanceMatches.length) {
                                      return Column(
                                        children: [
                                          Expanded(
                                            child: ProfileCardWeb(
                                              profile: matchService
                                                  .romanceMatches[index],
                                              scrollController:
                                                  _scrollController,
                                            ),
                                          ),
                                          SizedBox(height: kIsWeb ? 50 : 8),
                                          Row(
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
                                                                          .romanceMatches
                                                                          .length -
                                                                      1 &&
                                                              _currentIndex !=
                                                                  0) {
                                                            print(
                                                                'Can\'t swipe any further!');
                                                            return;
                                                          }
                                                          // _debounceButton();
                                                          _swiperController
                                                              .swipeLeft();

                                                          /*
                        String swipedUserId =
                            matchService.romanceMatches[_currentIndex]
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
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
                                                                        .romanceMatches
                                                                        .length -
                                                                    1 &&
                                                            _currentIndex !=
                                                                0) {
                                                          print(
                                                              'Can\'t swipe any further!');
                                                          return;
                                                        }
                                                        //_debounceButton();
                                                        _swiperController
                                                            .swipeRight();
                                                        /*
                      String swipedUserId =
                          matchService.romanceMatches[_currentIndex]
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
                                                    color: Colors.black,
                                                    size: 40),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return SizedBox(); // Return an empty SizedBox if index is out of bounds
                                    }
                                  },
                                  cardCount: matchService.romanceMatches.length,
                                  swipeOptions: SwipeOptions.only(
                                    up: false,
                                    down: false,
                                    left: true,
                                    right: true,
                                  ),
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
