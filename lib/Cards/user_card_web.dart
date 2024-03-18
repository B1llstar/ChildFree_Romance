import 'package:cached_network_image/cached_network_image.dart';
import 'package:childfree_romance/Cards/interests_choice_chips.dart';
import 'package:childfree_romance/Cards/prompt_question_answer_row.dart';
import 'package:childfree_romance/Cards/triple_details_row.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'detail_row.dart';

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
        title: Text(profile['name'] ?? 'No name provided'),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                              DetailRow(
                                title: profile['isSterilized'] == 'Yes'
                                    ? 'Sterilized'
                                    : profile['isSterilized'] == 'No'
                                        ? 'Not Sterilized'
                                        : 'Will Sterilize',
                                icon: FontAwesomeIcons.briefcaseMedical,
                              ),
                              DetailRow(
                                  title: profile['willDoLongDistance'] == 'Yes'
                                      ? 'Not open to long-distance'
                                      : 'Not open to long-distance',
                                  icon: FontAwesomeIcons.globe),
                              DetailRow(
                                  title: profile['willRelocate'] == 'Yes'
                                      ? 'Open to relocating'
                                      : 'Not open to relocating',
                                  icon: FontAwesomeIcons.suitcaseRolling),
                              Divider(),
                              TripleDetailRow(icons: [
                                FontAwesomeIcons.beer,
                                FontAwesomeIcons.smoking,
                                FontAwesomeIcons.cannabis
                              ], titles: [
                                'Sometimes',
                                'No',
                                'Sometimes'
                              ]),
                              Divider(),
                              PromptQuestionAnswerRow(
                                  question: 'About Me',
                                  answer: profile['aboutMe']),
                              PromptQuestionAnswerRow(
                                  question: 'My dream match is...',
                                  answer: profile['dreamPartner']),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InterestsChoiceChipDisplay(
                                        interests:
                                            profile['selectedInterests'] ?? [])
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
