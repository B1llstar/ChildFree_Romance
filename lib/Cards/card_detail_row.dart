import 'package:flutter/material.dart';

class CardDetail extends StatefulWidget {
  final IconData icon;
  final title;
  const CardDetail({super.key, required this.icon, required this.title});

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Icon(widget.icon, size: 32),
          SizedBox(width: 8),
          Text(widget.title.toString())
        ]),
      ),
    );
  }
}
