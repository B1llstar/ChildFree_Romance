import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatWidget extends StatefulWidget {
  final String matchId;

  const ChatWidget({Key? key, required this.matchId}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Chat(
        onSendPressed: (message) {
          print('Sending message');
        },
        messages: [], // Provide your messages here

        user: types.User(id: 'user'),
      ),
    );
  }
}
