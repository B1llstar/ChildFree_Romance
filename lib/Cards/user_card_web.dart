import 'package:childfree_romance/Cards/interests_choice_chips.dart';
import 'package:childfree_romance/Cards/triple_details_row.dart';
import 'package:childfree_romance/Cards/triple_prompt_widget.dart';
import 'package:childfree_romance/Screens/profile_pictures_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../distance_calculator.dart';

class ProfileCardWeb extends StatefulWidget {
  final Map<String, dynamic> profile;
  final ScrollController scrollController;
  // Function callback
  final void Function() onDownArrowPress;

  const ProfileCardWeb(
      {Key? key,
      required this.profile,
      required this.scrollController,
      required this.onDownArrowPress})
      : super(key: key);

  @override
  _ProfileCardWebState createState() => _ProfileCardWebState();
}

class _ProfileCardWebState extends State<ProfileCardWeb> {
  @override
  void initState() {
    super.initState();
  }

  void scrollDownSlightly() {
    widget.onDownArrowPress();
  }

  @override
  Widget build(BuildContext context) {
    double? width;
    if (!kIsWeb)
      width = MediaQuery.of(context).size.width < 550 ? 500 : 550;
    else
      width = MediaQuery.of(context).size.width < 1000
          ? MediaQuery.of(context).size.width
          : 1000;

    int calculateAge(DateTime dob) {
      DateTime now = DateTime.now();
      int years = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        years--;
      }
      return years;
    }

    List<dynamic> interests = widget.profile['selectedInterests'] ?? [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * .65,
          width: 600,
          child: ListView(
            controller: widget.scrollController,
            children: [
              ProfilePicturesWidget(
                profile: widget.profile,
                onDownArrowPress: scrollDownSlightly,
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TripleDetailRow(
                    titles: [
                      DistanceCalculator().getLocationString(widget.profile)
                    ],
                    icons: [FontAwesomeIcons.locationArrow],
                  ),
                ],
              ),
              if (widget.profile['DOB'] != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TripleDetailRow(
                      titles: [
                        '${calculateAge(widget.profile['DOB'].toDate())}',
                        widget.profile['isSterilized'] == 'Yes'
                            ? 'Sterilized'
                            : widget.profile['isSterilized'] == 'No'
                                ? 'Not Sterilized'
                                : 'Will Sterilize',
                        widget.profile['sexuality']
                      ],
                      icons: [
                        FontAwesomeIcons.birthdayCake,
                        FontAwesomeIcons.briefcaseMedical,
                        FontAwesomeIcons.smileWink
                      ],
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TripleDetailRow(
                      titles: [
                        widget.profile['isSterilized'] == 'Yes'
                            ? 'Sterilized'
                            : widget.profile['isSterilized'] == 'No'
                                ? 'Not Sterilized'
                                : 'Will Sterilize',
                        widget.profile['sexuality']
                      ],
                      icons: [
                        FontAwesomeIcons.briefcaseMedical,
                        FontAwesomeIcons.smileWink
                      ],
                    ),
                  ],
                ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TripleDetailRow(
                    titles: [
                      widget.profile['job'],
                      widget.profile['educationLevel']
                    ],
                    icons: [
                      FontAwesomeIcons.briefcase,
                      FontAwesomeIcons.school
                    ],
                  ),
                ],
              ),
              if ((widget.profile['job'] != null &&
                      widget.profile['job'].isNotEmpty) ||
                  (widget.profile['educationLevel'] != null &&
                      widget.profile['educationLevel'].isNotEmpty))
                Divider(),
              if (!kIsWeb)
                TripleDetailRow(
                  icons: [
                    FontAwesomeIcons.globe,
                    FontAwesomeIcons.suitcaseRolling
                  ],
                  titles: [
                    widget.profile['willDoLongDistance'] == 'Yes'
                        ? 'Not open to long-distance'
                        : 'Not open to long-distance',
                    widget.profile['willRelocate'] == 'Yes'
                        ? 'Open to relocating'
                        : 'Not open to relocating',
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TripleDetailRow(
                      icons: [
                        FontAwesomeIcons.globe,
                        FontAwesomeIcons.suitcaseRolling
                      ],
                      titles: [
                        widget.profile['willDoLongDistance'] == 'Yes'
                            ? 'Not open to long-distance'
                            : 'Not open to long-distance',
                        widget.profile['willRelocate'] == 'Yes'
                            ? 'Open to relocating'
                            : 'Not open to relocating',
                      ],
                    ),
                  ],
                ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TripleDetailRow(
                    icons: [
                      FontAwesomeIcons.beer,
                      FontAwesomeIcons.smoking,
                      FontAwesomeIcons.cannabis
                    ],
                    titles: [
                      widget.profile['doesDrink'],
                      widget.profile['doesSmoke'],
                      widget.profile['does420']
                    ],
                  ),
                ],
              ),
              if ((widget.profile['politics'] != null &&
                      widget.profile['politics'].isNotEmpty) ||
                  (widget.profile['religion'] != null &&
                      widget.profile['religion'].isNotEmpty))
                Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TripleDetailRow(
                    icons: [FontAwesomeIcons.landmark, FontAwesomeIcons.pray],
                    titles: [
                      widget.profile['politics'],
                      widget.profile['religion']
                    ],
                  ),
                ],
              ),
              TriplePromptWidget(profile: widget.profile),
              if (interests.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InterestsChoiceChipDisplay(
                        interests: interests,
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }
}
