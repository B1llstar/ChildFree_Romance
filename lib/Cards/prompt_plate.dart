import 'package:flutter/material.dart';

class Prompt extends StatefulWidget {
  final String prompt;
  final String answer;
  const Prompt({super.key, required this.prompt, required this.answer});

  @override
  State<Prompt> createState() => _PromptState();
}

class _PromptState extends State<Prompt> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      Text(widget.prompt,
          style: TextStyle(
            fontSize: 24,
          )),
      Text(widget.answer,
          style: TextStyle(
            fontSize: 28,
          ))
    ]));
  }
}
