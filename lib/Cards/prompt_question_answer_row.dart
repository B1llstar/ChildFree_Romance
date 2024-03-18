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
      Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Text(
            widget.question,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          )),
      Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(widget.answer,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center),
      ),
      Divider(),
    ]);
  }
}
