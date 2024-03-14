import 'package:cached_network_image/cached_network_image.dart';
import 'package:childfree_romance/Cards/user_card_base_settings_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class ProfileCardWeb extends StatefulWidget {
  final Map<String, dynamic> profile;
  final FlipCardController flipCardController;
  const ProfileCardWeb(
      {Key? key, required this.profile, required this.flipCardController})
      : super(key: key);

  @override
  State<ProfileCardWeb> createState() => _ProfileCardWebState();
}

class _ProfileCardWebState extends State<ProfileCardWeb> {
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
    return FlipCard(
      controller: widget.flipCardController,
      axis: FlipAxis.vertical,
      onTapFlipping: true,
      animationDuration: Duration(milliseconds: 200),
      rotateSide: RotateSide.right,
      backWidget: Container(
        constraints: BoxConstraints(maxWidth: width),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Stack(
            children: [
              Container(
                height: !kIsWeb
                    ? MediaQuery.of(context).size.height * .77
                    : MediaQuery.of(context).size.height * .77,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        widget.profile.containsKey('profilePictures')
                            ? widget.profile['profilePictures'][0]
                            : 'Crigne'),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ProfileCardBaseSettingsComponent(profile: widget.profile)
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 50,
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
      frontWidget: Container(
        constraints: BoxConstraints(maxWidth: width),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Stack(
            children: [
              Container(
                height: !kIsWeb
                    ? MediaQuery.of(context).size.height * .77
                    : MediaQuery.of(context).size.height * .77,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          widget.profile.containsKey('profilePictures')
                              ? widget.profile['profilePictures'][0]
                              : 'Crigne')),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ProfileCardBaseSettingsComponent(profile: widget.profile)
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 50,
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
    );
  }
}
