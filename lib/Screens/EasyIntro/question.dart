import 'package:childfree_romance/Screens/EasyIntro/interests_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/user_notifier.dart';

class QuestionWidget extends StatefulWidget {
  final String property;
  final String title;
  final String assetImageUrl;
  final List<String> options;
  final void Function(String, String) onButtonPressed;
  final int index;
  final Function(List<String>) onItemsSelected;

  const QuestionWidget(
      {Key? key,
      required this.property,
      required this.title,
      required this.assetImageUrl,
      required this.options,
      required this.onButtonPressed,
      required this.index,
      required this.onItemsSelected})
      : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  UserDataProvider? _userDataNotifier;

  @override
  void initState() {
    super.initState();
  }

  void onItemsSelected(List<String> items) {
    widget.onItemsSelected(items);
  }

  @override
  Widget build(BuildContext context) {
    _userDataNotifier ??= Provider.of<UserDataProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: widget.property == 'interests' ? 600 : 400,
          width: 500,
          child: Card(
            elevation: 2,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  if (widget.property == 'interests')
                    _buildInterestsQuestionCard(
                      (interests) {
                        widget.onItemsSelected(interests);
                      },
                    )
                  else
                    _buildNormalQuestionCard(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalQuestionCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          widget.assetImageUrl,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildOptionButtons(),
        ),
      ],
    );
  }

  List<Widget> _buildOptionButtons() {
    return widget.options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      return ElevatedButton(
        onPressed: () {
          setState(() {
            _userDataNotifier!.choices[widget.index] = index;
          });
          widget.onButtonPressed(widget.property, option);
        },
        style: ButtonStyle(
          backgroundColor: _userDataNotifier!.choices[widget.index] == index
              ? MaterialStateProperty.all(Colors.green)
              : null,
        ),
        child: Text(option),
      );
    }).toList();
  }

  Widget _buildInterestsQuestionCard(
      void Function(List<String>) onItemsSelected) {
    return InterestsQuestionCard(
      options: widget.options,
      onInterestsSelected: (selectedInterests) {
        widget.onButtonPressed(widget.property, selectedInterests.join(', '));
        widget.onItemsSelected(selectedInterests);
      },
    );
  }
}
