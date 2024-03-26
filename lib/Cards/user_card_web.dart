import 'package:childfree_romance/Cards/interests_choice_chips.dart';
import 'package:childfree_romance/Cards/triple_details_row.dart';
import 'package:childfree_romance/Cards/triple_prompt_widget.dart';
import 'package:childfree_romance/Screens/profile_pictures_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../distance_calculator.dart';

class ProfileCardWeb extends StatelessWidget {
  final Map<String, dynamic> profile;
  final ScrollController scrollController;
  const ProfileCardWeb(
      {Key? key, required this.profile, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // A width that is no greater than 500
    double? width;
    if (!kIsWeb)
      width = MediaQuery.of(context).size.width < 550 ? 500 : 550;
    else
      width = MediaQuery.of(context).size.width < 1000
          ? MediaQuery.of(context).size.width
          : 1000;

    // Function to calculate age from Firestore Timestamp
    int calculateAge(Timestamp dobTimestamp) {
      DateTime dob = dobTimestamp.toDate();
      DateTime now = DateTime.now();
      int years = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        years--;
      }
      return years;
    }

    List<dynamic> interests = profile['selectedInterests'] ?? [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Stack(
                    children: [
                      // The height of the card
                      Container(
                        height: !kIsWeb
                            ? MediaQuery.of(context).size.height * .8
                            : MediaQuery.of(context).size.height * 1,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ProfilePicturesWidget(profile: profile),
                              /*
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) {
                                    return Shimmer(
                                      gradient: LinearGradient(
                                        colors: [Colors.grey, Colors.white],
                                      ),
                                      child: Container(
                                        height: 500,
                                        width: 500,
                                        child: Card(),
                                      ),
                                    );
                                  },
                                  height: 400,
                                  width: width,
                                  fit: kIsWeb
                                      ? BoxFit.fitHeight
                                      : BoxFit.fitWidth,
                                  imageUrl: profile
                                              .containsKey('profilePictures') &&
                                          profile['profilePictures'] != null &&
                                          profile['profilePictures'].length > 0
                                      ? profile['profilePictures'][0]
                                      : 'Crigne',
                                ),
                              ),

                               */
                              SizedBox(height: 4),
                              TripleDetailRow(
                                titles: [
                                  DistanceCalculator()
                                      .getLocationString(profile)
                                ],
                                icons: [FontAwesomeIcons.locationArrow],
                              ),
                              if (profile['DOB'] != null)
                                TripleDetailRow(
                                  titles: [
                                    '${calculateAge(profile['DOB'])}',
                                    profile['isSterilized'] == 'Yes'
                                        ? 'Sterilized'
                                        : profile['isSterilized'] == 'No'
                                            ? 'Not Sterilized'
                                            : 'Will Sterilize',
                                    profile['sexuality']
                                  ],
                                  icons: [
                                    FontAwesomeIcons.birthdayCake,
                                    FontAwesomeIcons.briefcaseMedical,
                                    FontAwesomeIcons.smileWink
                                  ],
                                )
                              else
                                TripleDetailRow(
                                  titles: [
                                    profile['isSterilized'] == 'Yes'
                                        ? 'Sterilized'
                                        : profile['isSterilized'] == 'No'
                                            ? 'Not Sterilized'
                                            : 'Will Sterilize',
                                    profile['sexuality']
                                  ],
                                  icons: [
                                    FontAwesomeIcons.briefcaseMedical,
                                    FontAwesomeIcons.smileWink
                                  ],
                                ),
                              Divider(),
                              TripleDetailRow(
                                titles: [
                                  profile['job'],
                                  profile['educationLevel']
                                ],
                                icons: [
                                  FontAwesomeIcons.briefcase,
                                  FontAwesomeIcons.school
                                ],
                              ),
                              if (profile['job'] != null &&
                                      profile['job'].isNotEmpty ||
                                  profile['educationLevel'] != null &&
                                      profile['educationLevel'].isNotEmpty)
                                Divider(),
                              TripleDetailRow(
                                icons: [
                                  FontAwesomeIcons.globe,
                                  FontAwesomeIcons.suitcaseRolling
                                ],
                                titles: [
                                  profile['willDoLongDistance'] == 'Yes'
                                      ? 'Not open to long-distance'
                                      : 'Not open to long-distance',
                                  profile['willRelocate'] == 'Yes'
                                      ? 'Open to relocating'
                                      : 'Not open to relocating',
                                ],
                              ),
                              Divider(),
                              TripleDetailRow(
                                icons: [
                                  FontAwesomeIcons.beer,
                                  FontAwesomeIcons.smoking,
                                  FontAwesomeIcons.cannabis
                                ],
                                titles: [
                                  profile['doesDrink'],
                                  profile['doesSmoke'],
                                  profile['does420']
                                ],
                              ),
                              profile['politics'] != null &&
                                          profile['politics'].isNotEmpty ||
                                      profile['religion'] != null &&
                                          profile['religion'].isNotEmpty
                                  ? Divider()
                                  : Container(),
                              TripleDetailRow(icons: [
                                FontAwesomeIcons.landmark,
                                FontAwesomeIcons.pray
                              ], titles: [
                                profile['politics'],
                                profile['religion']
                              ]),
                              TriplePromptWidget(profile: profile),
                              interests.length > 0
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InterestsChoiceChipDisplay(
                                            interests:
                                                profile['selectedInterests'] ??
                                                    [],
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
