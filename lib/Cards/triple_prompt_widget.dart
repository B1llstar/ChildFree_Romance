import 'package:childfree_romance/Cards/prompt_question_answer_row.dart';
import 'package:flutter/material.dart';

class TriplePromptWidget extends StatelessWidget {
  final Map<String, dynamic> profile;

  const TriplePromptWidget({required this.profile});

  @override
  Widget build(BuildContext context) {
    final prompt1 = profile['prompt_1'];
    final prompt2 = profile['prompt_2'];
    final prompt3 = profile['prompt_3'];

    List<Widget> widgets = [];

    if (prompt1 != null &&
        prompt1['prompt'] != null &&
        prompt1['answer'] != null &&
        prompt1['prompt'].isNotEmpty &&
        prompt1['answer'].isNotEmpty) {
      widgets.addAll(
        [
          Divider(),
          PromptQuestionAnswerRow(
            question: prompt1['prompt'],
            answer: prompt1['answer'],
          )
        ],
      );
    }

    if (prompt2 != null &&
        prompt2['prompt'] != null &&
        prompt2['answer'] != null &&
        prompt2['prompt'].isNotEmpty &&
        prompt2['answer'].isNotEmpty) {
      widgets.addAll(
        [
          Divider(),
          PromptQuestionAnswerRow(
            question: prompt2['prompt'],
            answer: prompt2['answer'],
          )
        ],
      );
    }

    if (prompt3 != null &&
        prompt3['prompt'] != null &&
        prompt3['answer'] != null &&
        prompt3['prompt'].isNotEmpty &&
        prompt3['answer'].isNotEmpty) {
      widgets.addAll(
        [
          Divider(),
          PromptQuestionAnswerRow(
            question: prompt3['prompt'],
            answer: prompt3['answer'],
          ),
        ],
      );
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: widgets,
      ),
    );
  }
}
