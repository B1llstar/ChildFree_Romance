import 'package:cached_network_image/cached_network_image.dart';
import 'package:childfree_romance/Cards/interests_choice_chips.dart';
import 'package:childfree_romance/Cards/prompt_plate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'card_detail_row.dart';

class ProfileCardWeb extends StatelessWidget {
  final Map<String, dynamic> profile;

  const ProfileCardWeb({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // A width that is no greater than 500
    double? width;
    if (!kIsWeb)
      width = MediaQuery.of(context).size.width < 500 ? 500 : 500;
    else
      width = MediaQuery.of(context).size.width < 1000
          ? MediaQuery.of(context).size.width
          : 1000;

    return Scaffold(
      appBar: AppBar(
        title: Text(profile['name']),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: width,
                    maxHeight: MediaQuery.of(context).size.height * 1),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Stack(
                    children: [
                      Container(
                        height: !kIsWeb
                            ? MediaQuery.of(context).size.height * .61
                            : MediaQuery.of(context).size.height * 1,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Card(
                                elevation: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
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
                                    height: MediaQuery.of(context).size.height *
                                        .50,
                                    width: width,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        profile.containsKey('profilePictures')
                                            ? profile['profilePictures'][0]
                                            : 'Crigne',
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CardDetail(
                                      icon: FontAwesomeIcons.briefcaseMedical,
                                      title: profile['isSterilized'] == 'Yes'
                                          ? 'Sterilized'
                                          : profile['isSterilized'] == 'No'
                                              ? 'Not Sterilized'
                                              : 'Will Sterilize',
                                    ),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CardDetail(
                                        icon: FontAwesomeIcons.briefcaseMedical,
                                        title: profile['willDoLongDistance'] ==
                                                'Yes'
                                            ? 'Will do long-distance'
                                            : 'Will not do long-distance'),
                                    CardDetail(
                                      icon: FontAwesomeIcons.briefcaseMedical,
                                      title: profile['willRelocate'] == 'Yes'
                                          ? 'Willing to relocate'
                                          : profile['isSterilized'] == 'No'
                                              ? 'Not willing to relocate'
                                              : 'Will consider relocating',
                                    ),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CardDetail(
                                        icon: FontAwesomeIcons.wineGlass,
                                        title: profile['doesDrink'] ?? 'No'),
                                    CardDetail(
                                        icon: Icons.smoking_rooms,
                                        title: profile['doesSmoke'] ?? 'No'),
                                    CardDetail(
                                        icon: FontAwesomeIcons.cannabis,
                                        title: profile['does420'] ?? 'No'),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Prompt(
                                        prompt: 'About Me',
                                        answer: profile['aboutMe'] ??
                                            'None provided',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (profile['dreamPartner'] != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Prompt(
                                          prompt: 'My dream partner is...',
                                          answer: profile['dreamPartner'],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InterestsChoiceChipDisplay(
                                        interests: profile['selectedInterests'])
                                  ])
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
