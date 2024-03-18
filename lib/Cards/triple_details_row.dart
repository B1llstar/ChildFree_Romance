import 'package:flutter/material.dart';

class TripleDetailRow extends StatelessWidget {
  final List<IconData> icons;
  final List<String> titles;

  const TripleDetailRow({Key? key, required this.icons, required this.titles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          icons.length,
          (index) => Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11.0),
            child: Row(
              children: [
                Icon(icons[index]),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(titles[index], style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}