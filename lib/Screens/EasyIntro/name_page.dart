import 'package:flutter/material.dart';

import '../../Notifiers/user_notifier.dart';

class NamePage extends StatefulWidget {
  final TextEditingController controller;
  final UserDataProvider userDataNotifier;
  const NamePage(
      {Key? key, required this.controller, required this.userDataNotifier})
      : super(key: key);

  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.userDataNotifier.name;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurpleAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 400,
            width: 500,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'What\'s your name?',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 300,
                      child: TextField(
                        controller: widget.controller,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          widget.userDataNotifier.name = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
