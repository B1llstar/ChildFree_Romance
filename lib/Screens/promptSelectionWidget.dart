import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FirestorePromptsWidget extends StatefulWidget {
  final String userId;

  FirestorePromptsWidget({required this.userId});

  @override
  _FirestorePromptsWidgetState createState() => _FirestorePromptsWidgetState();
}

class _FirestorePromptsWidgetState extends State<FirestorePromptsWidget> {
  late TextEditingController _answerController;
  late List<String> _promptList;
  late String? _selectedPromptName;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController();
    _promptList = [
      "The best part about being childfree",
      "My childfree hero",
      "A short term goal",
      "A life goal",
      "I knew I was childfree when"
    ]; // Combined prompt list
    _selectedPromptName = null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('test_users')
          .doc(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
            child: Text('No data available'),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final prompt1 = data['prompt_1'];
        final prompt2 = data['prompt_2'];
        final prompt3 = data['prompt_3'];

        return SettingsSection(
          tiles: [
            _buildPromptTileWithLeading('Prompt 1', prompt1),
            _buildPromptTile('Prompt 2', prompt2),
            _buildPromptTile('Prompt 3', prompt3),
          ],
        );
      },
    );
  }

  SettingsTile _buildPromptTile(
      String promptName, Map<String, dynamic>? promptData) {
    final prompt = promptData?['prompt'] ?? '';
    final answer = promptData?['answer'] ?? 'No answer yet';

    return SettingsTile(
      title: Text(promptData?['prompt'] ?? 'Choose a prompt'),
      description: Text(answer),
      onPressed: (context) {
        _showPromptSelectionDialog(promptName, prompt, answer);
      },
    );
  }

  SettingsTile _buildPromptTileWithLeading(
      String promptName, Map<String, dynamic>? promptData) {
    final prompt = promptData?['prompt'] ?? '';
    final answer = promptData?['answer'] ?? 'No answer yet';

    return SettingsTile(
      leading: Icon(FontAwesomeIcons.solidStar, color: Colors.yellow),
      title: Text(promptData?['prompt'] ?? 'Choose a prompt'),
      description: Text(answer),
      onPressed: (context) {
        _showPromptSelectionDialog(promptName, prompt, answer);
      },
    );
  }

  Future<void> _showPromptSelectionDialog(
      String promptName, String currentPrompt, String currentAnswer) async {
    _selectedPromptName = currentPrompt;

    // Set initial value for answer text field
    _answerController.text = currentAnswer;

    // Ensure current prompt is in the prompt list
    if (!_promptList.contains(currentPrompt)) {
      _promptList.add(currentPrompt);
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Prompt'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: _selectedPromptName,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedPromptName = newValue!;
                      });
                    },
                    items: _promptList.map((String prompt) {
                      return DropdownMenuItem<String>(
                        value: prompt,
                        child: Text(prompt),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _answerController,
                    decoration: InputDecoration(
                      hintText: 'Enter your answer...',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    _updatePrompt(promptName, _selectedPromptName,
                        _answerController.text);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updatePrompt(
      String promptName, String? selectedPromptName, String answer) {
    final snakeCasePromptName =
        'prompt_${promptName.split(' ')[1]}'; // Convert prompt name to snake case
    FirebaseFirestore.instance.collection('test_users').doc(widget.userId).set(
      {
        snakeCasePromptName: {
          'prompt': selectedPromptName,
          'answer': answer,
        }
      },
      SetOptions(merge: true),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
