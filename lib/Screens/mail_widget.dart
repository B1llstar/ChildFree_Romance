import 'package:flutter/material.dart';

import 'email_service.dart'; // Import your mail service package

class MailWidget extends StatefulWidget {
  @override
  _MailWidgetState createState() => _MailWidgetState();
}

class _MailWidgetState extends State<MailWidget> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final MailService _mailService = MailService();

  void _sendMail() async {
    String uid = ''; // Provide the user ID here
    bool success = await _mailService.sendMail(
      'billborkowski7@gmail.com',
      'You have a new match on Childfree Connection!',
      'View your match on our website at https://childfreeconnection.us :)',
    );
    if (success) {
      // Mail sent successfully
      // You can add your success logic here
    } else {
      // Mail sending failed
      // You can add your failure logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mail Widget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Body',
              ),
              maxLines: null, // Allow multiline input
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _sendMail,
              child: Text('Send Mail'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
