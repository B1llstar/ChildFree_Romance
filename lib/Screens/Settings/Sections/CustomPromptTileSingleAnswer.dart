import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:provider/provider.dart';

import '../../../Notifiers/user_notifier.dart';
import 'sentence_picker_page.dart'; // Assuming you have the SentencePickerPage implemented

class CustomPromptSettingsAnswer extends StatefulWidget {
  final String firestorePropertyName;
  final String title;
  final BuildContext myContext;

  const CustomPromptSettingsAnswer({
    Key? key,
    required this.firestorePropertyName,
    required this.title,
    required this.myContext,
  }) : super(key: key);

  @override
  State<CustomPromptSettingsAnswer> createState() =>
      _CustomPromptSettingsAnswerState();
}

class _CustomPromptSettingsAnswerState
    extends State<CustomPromptSettingsAnswer> {
  @override
  Widget build(BuildContext context) {
    String description = Provider.of<UserDataProvider>(widget.myContext)
            .getProperty(widget.firestorePropertyName) ??
        '';
    return SettingsTile(
      title: Text(widget.title),
      description: Text(description),
      onPressed: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SentencePickerPage(
              onSelect: (selectedSentence) {
                _showResponsePage(selectedSentence);
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showResponsePage(String selectedSentence) async {
    final response = await Navigator.push(
      widget.myContext,
      MaterialPageRoute(
        builder: (context) => ResponsePage(
          prompt: selectedSentence,
        ),
      ),
    );
    if (response != null) {
      Provider.of<UserDataProvider>(widget.myContext, listen: false)
          .setProperty(widget.firestorePropertyName, response);
    }
  }
}

class ResponsePage extends StatefulWidget {
  final String prompt;

  const ResponsePage({Key? key, required this.prompt}) : super(key: key);

  @override
  _ResponsePageState createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Response'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prompt:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(widget.prompt),
            SizedBox(height: 16),
            Text(
              'Your Response:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _textEditingController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your response here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _textEditingController.text);
              },
              child: Text('Save Response'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
