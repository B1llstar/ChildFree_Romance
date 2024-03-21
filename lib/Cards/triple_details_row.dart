import 'package:flutter/material.dart';

class TripleDetailRow extends StatelessWidget {
  final List<IconData> icons;
  final List<String?> titles;

  const TripleDetailRow({
    Key? key,
    required this.icons,
    required this.titles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    for (int i = 0; i < icons.length; i++) {
      if (titles[i] != null && titles[i]!.isNotEmpty) {
        widgets.addAll(
          [
            Divider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 11.0),
              child: Row(
                children: [
                  Icon(icons[i]),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(titles[i]!, style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }
}
