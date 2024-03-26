import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../Notifiers/all_users_notifier.dart';

class ChatWidget extends StatefulWidget {
  final String matchId;
  final String uid;
  final String profilePictureUrl;
  final AllUsersNotifier notifier;
  final String name;

  const ChatWidget(
      {Key? key,
      required this.matchId,
      required this.name,
      required this.uid,
      required this.profilePictureUrl,
      required this.notifier})
      : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  List<types.Message> _messages = [];
  List<types.TextMessage> textMessages = [];
  types.User? userAuthor;

  @override
  void initState() {
    super.initState();
    userAuthor = types.User(id: widget.uid);
    loadMessagesFromMatchId();
    // Listen for changes in the 'messages' property
    FirebaseFirestore.instance
        .collection('matches')
        .doc(widget.matchId)
        .snapshots()
        .listen((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final messages = data['messages'] as List<dynamic>;

        final lastMessage = messages.isNotEmpty ? messages.last : null;
        if (lastMessage != null) {
          final id = lastMessage['userId'] as String;
          final text = lastMessage['text'] as String;
          final newTextMessage = types.TextMessage(
            id: Uuid().v4(),
            author: types.User(id: id),
            text: text,
          );
          print('ID: $id');
          if (id != widget.uid) {
            addTextMessageToMessages(newTextMessage);
          } else {
            print('Message belongs to the user');
          }
        }
      }
    });
  }

  Future<void> sendPushNotification(String userId, String messageTitle,
      String messageBody, String type, String id) async {
    try {
      // Define the URL of your Cloud Function
      final url = 'https://aianyone.net/cfc/send_notification_to_device';

      // Define the request body
      final body = json.encode({
        'userId': userId,
        "title": messageTitle,
        "body": messageBody,
        "type": type,
        "id": id
      });

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
  }

  void loadMessagesFromMatchId() async {
    final matchDoc = await FirebaseFirestore.instance
        .collection('matches')
        .doc(widget.matchId)
        .get();
    if (matchDoc.exists) {
      final messages = matchDoc.data()?['messages'] as List<dynamic>? ?? [];
      updateMessages(messages);
    }
  }

  void updateMessages(List<dynamic> messages) {
    final newMessages = messages.map<types.Message>((messageData) {
      final id = messageData['userId'] as String;
      final text = messageData['text'] as String;
      final newTextMessage = types.TextMessage(
        id: Uuid().v4(),
        author: types.User(id: id),
        text: text,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      return newTextMessage;
    }).toList();

    setState(() {
      newMessages.forEach((message) {
        _messages.insert(0, message);
      });
    });
  }

  void addTextMessageToMessages(types.TextMessage textMessage) {
    setState(() {
      _messages.insert(0, textMessage);
    });
  }

  void simulateMessageFromAnotherUser() {
    // Simulate a message from another user
    final newTextMessage = types.TextMessage(
      id: Uuid().v4(),
      author: types.User(id: 'other_user_id'),
      text: 'Hello, how are you?',
    );
    addTextMessageToMessages(newTextMessage);
  }

  void addSimulatedMessageToFirestoreStream() {
    // Simulate a message from another user
    final newTextMessage = types.TextMessage(
      id: Uuid().v4(),
      author: types.User(id: 'other_user_id'),
      text: 'Hello, how are you?',
    );
    // Upload to Firestore
    uploadTextToMessageFirestore('Hello, how are you?');
  }

  void _handleSendPressed(String text) async {
    final newTextMessage = types.TextMessage(
      id: Uuid().v4(),
      author: userAuthor!,
      text: text,
    );

    // Add the message to the local list immediately
    addTextMessageToMessages(newTextMessage);

    // Get Snapshot of matches document
    DocumentSnapshot matchesCollection = await FirebaseFirestore.instance
        .collection('matches')
        .doc(widget.matchId)
        .get();
    Map<String, dynamic> data =
        matchesCollection.data() as Map<String, dynamic>;
    List<dynamic> userIds = data['userIds'] as List<dynamic>;
    userIds.removeWhere((element) => element == widget.uid);
    String idToSendNotification = userIds[0];
    sendPushNotification(idToSendNotification, 'You have a new message!', '',
        "chatMessage", "-1");

    // Upload the message to Firestore
    try {
      await uploadTextToMessageFirestore(text);
    } catch (e) {
      // Handle error if upload fails
      print('Error uploading message: $e');
      // Remove the message from the local list if upload fails
      removeTextMessageFromMessages(newTextMessage);
    }
  }

// Method to remove a message from the local list
  void removeTextMessageFromMessages(types.TextMessage message) {
    setState(() {
      _messages.remove(message);
    });
  }

  Future<void> uploadTextToMessageFirestore(String text,
      {bool isTesting = false}) async {
    final matchesCollection = FirebaseFirestore.instance.collection('matches');
    final object = {
      'userId': isTesting ? '123' : widget.uid,
      'text': text,
      'timestamp': Timestamp.now(),
    };
    await matchesCollection.doc(widget.matchId).set(
      {
        'messages': FieldValue.arrayUnion([object])
      },
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.moon),
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
          ),
          Switch(
              value: widget.notifier.darkMode,
              onChanged: (value) {
                setState(() {
                  widget.notifier.darkMode = value;
                });
              }),
        ],
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Text(widget.name, style: TextStyle(fontSize: 32)),
          CachedNetworkImage(
              height: 200, width: 200, imageUrl: widget.profilePictureUrl),
          Container(
            child: Expanded(
              child: Chat(
                onSendPressed: (message) {
                  _handleSendPressed(message.text);
                },
                theme: widget.notifier.darkMode
                    ? DarkChatTheme()
                    : DefaultChatTheme(primaryColor: Colors.black87),
                messages: _messages,
                user: userAuthor!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
