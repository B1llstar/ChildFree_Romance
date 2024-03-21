import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String lastMessage;

  const MatchCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
  }) : super(key: key);

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          child: widget.imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              : Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.lastMessage,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
