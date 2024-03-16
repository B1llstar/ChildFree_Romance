import 'package:cached_network_image/cached_network_image.dart';
import 'package:childfree_romance/Cards/user_card_base_settings_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:shimmer/shimmer.dart';

class ProfileCard extends StatefulWidget {
  final Map<String, dynamic> profile;
  final FlipCardController flipCardController;
  const ProfileCard(
      {Key? key, required this.profile, required this.flipCardController})
      : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
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
    // Get current user from our notifier
    return SingleChildScrollView(
      child: FlipCard(
        controller: widget.flipCardController,
        axis: FlipAxis.vertical,
        onTapFlipping: true,
        animationDuration: Duration(milliseconds: 200),
        rotateSide: RotateSide.right,
        backWidget: Container(
          constraints: BoxConstraints(maxWidth: width),
          child: Shimmer(
            gradient: LinearGradient(
              colors: [Colors.grey, Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            child: Card(
              color: Colors.white,
              elevation: 4,
              child: Stack(
                children: [
                  Container(
                    height: !kIsWeb
                        ? MediaQuery.of(context).size.height * .70
                        : MediaQuery.of(context).size.height * .70,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(widget.profile
                                .containsKey('profilePictures')
                            ? widget.profile['profilePictures'][0]
                            : 'https://th.bing.com/th/id/OIP.92ht-gStSK-VSXyTA7JkcQHaHa?rs=1&pid=ImgDetMain'),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ProfileCardBaseSettingsComponent(
                            profile: widget.profile)
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        gradient: widget.profile['isLookingFor'] == 'Both'
                            ? LinearGradient(
                                colors: [Colors.yellow, Colors.purpleAccent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : null,
                        color: widget.profile['isLookingFor'] == 'Both'
                            ? null
                            : widget.profile['isLookingFor'] == 'Romance'
                                ? Colors.purpleAccent
                                : Colors.yellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        frontWidget: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: width),
            child: Card(
              color: Colors.white,
              elevation: 4,
              child: Stack(
                children: [
                  Container(
                    height: !kIsWeb
                        ? MediaQuery.of(context).size.height * .61
                        : MediaQuery.of(context).size.height * .61,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CachedNetworkImage(
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            return Shimmer(
                              gradient: LinearGradient(
                                colors: [Colors.grey, Colors.white],
                              ),
                              child: Container(
                                  height: 500, width: 500, child: Card()),
                            );
                          },
                          height: MediaQuery.of(context).size.height * .50,
                          width: width,
                          fit: BoxFit.cover,
                          imageUrl:
                              widget.profile.containsKey('profilePictures')
                                  ? widget.profile['profilePictures'][0]
                                  : 'Crigne',
                        ),
                        ProfileCardBaseSettingsComponent(
                            profile: widget.profile)
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        gradient: widget.profile['isLookingFor'] == 'Both'
                            ? LinearGradient(
                                colors: [Colors.yellow, Colors.purpleAccent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : null,
                        color: widget.profile['isLookingFor'] == 'Both'
                            ? null
                            : widget.profile['isLookingFor'] == 'Romance'
                                ? Colors.purpleAccent
                                : Colors.yellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
