import 'package:flutter/material.dart';

class InterestsChoiceChipDisplay extends StatefulWidget {
  final List<dynamic>? interests;
  const InterestsChoiceChipDisplay({Key? key, required this.interests})
      : super(key: key);

  @override
  State<InterestsChoiceChipDisplay> createState() =>
      _InterestsChoiceChipDisplayState();
}

class _InterestsChoiceChipDisplayState
    extends State<InterestsChoiceChipDisplay> {
  @override
  Widget build(BuildContext context) {
    if (widget.interests == null || widget.interests!.isEmpty) {
      return Container(); // Return a container if interests list is null or empty
    }
    return Expanded(
      child: Column(
        children: [
          Divider(),
          Text('Interests', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: [
                for (var interest in widget.interests!)
                  Chip(
                    label: Text(interest.toString()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
