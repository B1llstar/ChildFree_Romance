import 'package:flutter/material.dart';

class DetailRow extends StatefulWidget {
  final IconData icon;
  final String title;
  const DetailRow({super.key, required this.icon, required this.title});

  @override
  State<DetailRow> createState() => _DetailRowState();
}

class _DetailRowState extends State<DetailRow> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: 11),
      Icon(widget.icon),
      Padding(
          padding: EdgeInsets.all(8),
          child: Text(widget.title, style: TextStyle(fontSize: 16))),
    ]);
  }
}
