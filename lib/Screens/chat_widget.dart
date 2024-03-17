
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatWidget extends StatefulWidget {
  final String matchId;
  final String uid;
  const ChatWidget({Key? key, required this.matchId, required this.uid})
      : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  List<types.Message> _messages = [];
  List<dynamic> firestoreMessages = [];
  types.User? userAuthor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userAuthor = types.User(id: widget.uid);
    loadMessagesFromMatchId();
  }

  void loadMessagesFromMatchId() {
    print('Loading messages...');
    // Go to matches/{matchId} and grab the messages property
    final matchCollection = FirebaseFirestore.instance.collection('matches');
    matchCollection.doc(widget.matchId).get().then((doc) {
      if (doc.exists) {
        print('Doc exists!');
        firestoreMessages = doc.data()!['messages'];
        print('Messages: $firestoreMessages');
        convertFirestoreMessagesToTextMessages();
      }
    });
  }

  void convertFirestoreMessagesToTextMessages() {
    for (int i = 0; i < firestoreMessages.length; i++) {
      createNewTextMessage(
          firestoreMessages[i]['userId'], firestoreMessages[i]['text']);
    }
  }

  void createNewTextMessage(String id, String text) {
    types.TextMessage? textMessage;
    if (id == widget.uid) {
      textMessage = types.TextMessage(id: id, author: userAuthor!, text: text);
    } else {
      types.User author = types.User(id: id);
      textMessage = types.TextMessage(id: id, author: author, text: text);
    }
    addTextMessageToMessages(textMessage);
  }

  void _handleSendPressed(String text) async {
    createNewTextMessage(widget.uid, text);
    await uploadTextToMessageFirestore(text);
  }

  void addTextMessageToMessages(types.TextMessage textMessage) {
    setState(() {
      _messages.insert(0, textMessage);
    });
  }

  uploadTextToMessageFirestore(String text) async {
    final matchesCollection = FirebaseFirestore.instance.collection('matches');
    final object = {
      'userId': widget.uid,
      'text': text,
      'timestamp': Timestamp.now()
    };
    matchesCollection.doc(widget.matchId).set({
      'messages': FieldValue.arrayUnion([object])
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Chat(
        onSendPressed: (message) {
          print('Sending message');
          _handleSendPressed(message.text);
        },
        messages: _messages, // Provide your messages here

        user: userAuthor!,
      ),
    );
  }
}
