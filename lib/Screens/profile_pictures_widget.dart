import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePicturesWidget extends StatefulWidget {
  final Map<String, dynamic> profile;

  const ProfilePicturesWidget({Key? key, required this.profile})
      : super(key: key);

  @override
  _ProfilePicturesWidgetState createState() => _ProfilePicturesWidgetState();
}

class _ProfilePicturesWidgetState extends State<ProfilePicturesWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> profilePictures = widget.profile['profilePictures'] != null
        ? List<String>.from(widget.profile['profilePictures'])
        : [];

    // Extract pictures after the first index
    List<String> picturesToDisplay =
        profilePictures.length > 0 ? profilePictures.sublist(0) : [];

    // Return an empty container if no pictures after the first index
    if (picturesToDisplay.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: picturesToDisplay[currentIndex],
              progressIndicatorBuilder: (context, url, downloadProgress) {
                return Shimmer.fromColors(
                  child: Container(
                    height: 400,
                    width: 400,
                    color: Colors.white,
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                );
              },
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 400,
              width: 400,
              fit: BoxFit.cover,
            ),
            if (currentIndex > 0)
              Positioned(
                left: 10,
                child: IconButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  color: Colors.white,
                  icon: Icon(Icons.arrow_left, color: Colors.white, size: 32),
                  onPressed: () {
                    setState(() {
                      currentIndex--;
                    });
                  },
                ),
              ),
            if (currentIndex < picturesToDisplay.length - 1)
              Positioned(
                right: 10,
                child: IconButton(
                  color: Colors.white,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  icon: Icon(Icons.arrow_right, color: Colors.white, size: 32),
                  onPressed: () {
                    setState(() {
                      currentIndex++;
                    });
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }
}