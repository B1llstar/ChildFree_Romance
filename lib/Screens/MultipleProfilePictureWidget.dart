import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MultipleImagesSlider extends StatefulWidget {
  final List<dynamic> imageUrls;

  MultipleImagesSlider({required this.imageUrls});

  @override
  _MultipleImagesSliderState createState() => _MultipleImagesSliderState();
}

class _MultipleImagesSliderState extends State<MultipleImagesSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return Shimmer(
                      gradient: LinearGradient(
                        colors: [Colors.grey, Colors.white],
                      ),
                      child: Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: Card(),
                      ),
                    );
                  },
                  imageUrl: widget.imageUrls[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (_currentIndex > 0) {
                setState(() {
                  _currentIndex--;
                });
              }
            },
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              if (_currentIndex < widget.imageUrls.length - 1) {
                setState(() {
                  _currentIndex++;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
