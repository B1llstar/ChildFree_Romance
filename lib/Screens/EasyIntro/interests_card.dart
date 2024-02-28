import 'package:childfree_romance/Notifiers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterestsQuestionCard extends StatefulWidget {
  final List<String> options;
  final void Function(List<String>) onInterestsSelected;

  const InterestsQuestionCard({
    Key? key,
    required this.options,
    required this.onInterestsSelected,
  }) : super(key: key);

  @override
  _InterestsQuestionCardState createState() => _InterestsQuestionCardState();
}

class _InterestsQuestionCardState extends State<InterestsQuestionCard> {
  List<String> selectedInterests = [];
  UserDataProvider? userDataProvider;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userDataProvider =
        Provider.of<UserDataProvider>(context); // Initialize here
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 400, // Set your desired height here
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                for (var interest in widget.options)
                  ChoiceChip(
                    label: Text(interest),
                    selected:
                        userDataProvider!.selectedInterests!.contains(interest),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedInterests.add(interest);
                          print(
                              'User data provider null? ${userDataProvider == null}');
                          userDataProvider!.addToSelectedInterestList(interest);
                        } else {
                          selectedInterests.remove(interest);
                          userDataProvider!
                              .removeFromSelectedInterestList(interest);
                        }
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
