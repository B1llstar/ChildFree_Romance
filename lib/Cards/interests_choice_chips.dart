// Choice chips are disabled here, it's only for displaying on the card

import 'package:flutter/material.dart';

class InterestsChoiceChipDisplay extends StatefulWidget {
  final List<dynamic> interests;
  const InterestsChoiceChipDisplay({super.key, required this.interests});

  @override
  State<InterestsChoiceChipDisplay> createState() =>
      _InterestsChoiceChipDisplayState();
}

class _InterestsChoiceChipDisplayState
    extends State<InterestsChoiceChipDisplay> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Text('Interests', style: TextStyle(fontSize: 18))),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: [
                for (var interest in widget.interests)
                  Chip(
                    label: Text(interest),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
