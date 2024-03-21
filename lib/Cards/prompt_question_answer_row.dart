import 'package:flutter/material.dart';

class PromptQuestionAnswerRow extends StatefulWidget {
  final String question;
  final String answer;
  const PromptQuestionAnswerRow(
      {super.key, required this.question, required this.answer});

  @override
  State<PromptQuestionAnswerRow> createState() =>
      _PromptQuestionAnswerRowState();
}

class _PromptQuestionAnswerRowState extends State<PromptQuestionAnswerRow> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Text(
                  widget.question,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 0),
              child: Text(widget.answer,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    ]);
  }
}
