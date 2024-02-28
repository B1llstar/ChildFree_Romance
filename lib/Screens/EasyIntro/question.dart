import 'package:childfree_romance/Screens/EasyIntro/interests_card.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String property;
  final String title;
  final String assetImageUrl;
  final List<String> options;
  final void Function(String, String) onButtonPressed;

  const QuestionWidget({
    Key? key,
    required this.property,
    required this.title,
    required this.assetImageUrl,
    required this.options,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: property == 'interests' ? 600 : 400,
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
                    title,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  if (property == 'interests')
                    _buildInterestsQuestionCard()
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
          assetImageUrl,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var option in options)
              ElevatedButton(
                onPressed: () {
                  onButtonPressed(property, option);
                },
                child: Text(option),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInterestsQuestionCard() {
    return InterestsQuestionCard(
      options: options,
      onInterestsSelected: (selectedInterests) {
        onButtonPressed(property, selectedInterests.join(', '));
      },
    );
  }
}
