import 'package:childfree_romance/Cards/user_card_base_settings_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

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
    return FlipCard(
      controller: widget.flipCardController,
      axis: FlipAxis.vertical,
      onTapFlipping: true,
      animationDuration: Duration(milliseconds: 500),
      rotateSide: RotateSide.right,
      backWidget: Container(
        constraints: BoxConstraints(maxWidth: width),
        child: Card(
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20,
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

              Container(
                height: !kIsWeb
                    ? MediaQuery.of(context).size.height * 0.5
                    : MediaQuery.of(context).size.height * 0.5,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: NetworkImage(
                        widget.profile['profilePictures'][0] ?? 'Crigne'),
                    fit: BoxFit.cover,
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
              SizedBox(height: 8),

              // Insert anything we want to appear outside the card here
            ],
          ),
        ),
      ),
      frontWidget: Container(
        constraints: BoxConstraints(maxWidth: width),
        child: Card(
          color: Colors.deepPurpleAccent,
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20,
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

              Container(
                height: !kIsWeb
                    ? MediaQuery.of(context).size.height * 0.5
                    : MediaQuery.of(context).size.height * 0.5,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: NetworkImage(
                        widget.profile['profilePictures'][0] ?? 'Crigne'),
                    fit: BoxFit.cover,
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
              SizedBox(height: 8),

              // Insert anything we want to appear outside the card here
            ],
          ),
        ),
      ),
    );
  }
}
