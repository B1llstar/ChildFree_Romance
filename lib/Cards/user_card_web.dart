import 'package:cached_network_image/cached_network_image.dart';
import 'package:childfree_romance/Cards/interests_choice_chips.dart';
import 'package:childfree_romance/Cards/triple_details_row.dart';
import 'package:childfree_romance/Cards/triple_prompt_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.transparent),
                constraints: BoxConstraints(
                  maxWidth: width,
                  maxHeight: !kIsWeb
                      ? MediaQuery.of(context).size.height * .80
                      : MediaQuery.of(context).size.height * 1,
                ),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Stack(
                    children: [
                      // The height of the card
                      Container(
                        height: !kIsWeb
                            ? MediaQuery.of(context).size.height * .68
                            : MediaQuery.of(context).size.height * 1,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Text(
                                    profile['name'] ?? 'No Name Provided',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Divider(),
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
                                  imageUrl:
                                      profile.containsKey('profilePictures')
                                          ? profile['profilePictures'][0]
                                          : 'Crigne',
                                ),
                              ),
                              SizedBox(height: 4),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InterestsChoiceChipDisplay(
                                    interests:
                                        profile['selectedInterests'] ?? [],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
