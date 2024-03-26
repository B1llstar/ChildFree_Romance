import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card_provider.dart';

class TinderCard extends StatefulWidget {
  final Map<String, dynamic> profile;
  final bool isFront;
  const TinderCard({
    super.key,
    required this.profile,
    required this.isFront,
  });

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: widget.isFront ? buildFrontCard() : buildCard(),
    );
  }

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();
    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
            angle: -0.5, color: Colors.green, text: 'LIKE', opacity: opacity);
        return Positioned(top: 64, left: 50, child: child);
      case CardStatus.dislike:
        final child = buildStamp(
            angle: 0.5, color: Colors.red, text: 'NOPE', opacity: opacity);
        return Positioned(top: 64, right: 50, child: child);
      case CardStatus.superLike:
        final child = Center(
            child: buildStamp(
                color: Colors.blue, text: 'SUPER\nLIKE', opacity: opacity));
        return Positioned(bottom: 128, right: 0, left: 0, child: child);
      default:
        return Container();
    }
  }

  Widget buildStamp(
      {double angle = 0,
      required Color color,
      required String text,
      required double opacity}) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: 4),
            ),
            child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color, fontSize: 48, fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final provider = Provider.of<CardProvider>(context);
            final position = provider.position;

            final milliseconds = provider.isDragging ? 0 : 400;
            final center = constraints.smallest.center(Offset.zero);
            final angle = provider.angle * pi / 180;
            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);
            return AnimatedContainer(
                child: Stack(
                  children: [buildCard(), buildStamps()],
                ),
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: milliseconds),
                transform: rotatedMatrix..translate(position.dx, position.dy));
          },
        ),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition();
        },
      );

  Widget buildCard() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * .8,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              widget.profile['profilePictures'][0]),
                          fit: BoxFit.cover,
                          alignment: Alignment(-0.3, 0)))),
              Container(height: 100, width: 500, child: Text('Hi'))
            ],
          ),
        ),
      );
}
