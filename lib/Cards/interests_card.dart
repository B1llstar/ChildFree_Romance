import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterestsCard extends StatefulWidget {
  final List<String> options;
  final void Function(List<String>) onInterestsChanged;

  const InterestsCard({
    Key? key,
    required this.options,
    required this.onInterestsChanged,
  }) : super(key: key);

  @override
  _InterestsCardState createState() => _InterestsCardState();
}

class _InterestsCardState extends State<InterestsCard> {
  List<String> selectedInterests = [];
  AllUsersNotifier? _allUsersNotifier;

  @override
  Widget build(BuildContext context) {
    if (_allUsersNotifier == null) {
      _allUsersNotifier = Provider.of<AllUsersNotifier>(context);
      selectedInterests = _allUsersNotifier!.selectedInterests;
    }

    return SizedBox(
      height: 250,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                // Display selected interests above the options
                for (var selectedInterest in selectedInterests)
                  Chip(
                    label: Text(selectedInterest),
                    onDeleted: () {
                      setState(() {
                        selectedInterests.remove(selectedInterest);
                        widget.onInterestsChanged(selectedInterests);
                      });
                    },
                  ),
                // Display the options as choice chips
                for (var interest in widget.options)
                  ChoiceChip(
                    label: Text(interest),
                    selected: selectedInterests.contains(interest),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedInterests.add(interest);
                        } else {
                          selectedInterests.remove(interest);
                        }
                        widget.onInterestsChanged(selectedInterests);
                      });
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
