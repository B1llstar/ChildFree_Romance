import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/user_notifier.dart';

class QuestionWidget extends StatefulWidget {
  final String property;
  final String title;
  final String assetImageUrl;
  final List<String> options;
  final void Function(String, String) onButtonPressed;
  final List<String>? otherButtons;
  final int index;

  const QuestionWidget({
    Key? key,
    required this.property,
    required this.title,
    required this.assetImageUrl,
    required this.options,
    required this.onButtonPressed,
    this.otherButtons,
    required this.index,
  }) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  UserDataProvider? _userDataNotifier;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userDataNotifier ??= Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 400,
            width: 500,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      widget.assetImageUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < widget.options.length; i++)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _userDataNotifier!.choices[widget.index] = i;
                              });
                              widget.onButtonPressed(
                                  widget.property, widget.options[i]);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  _userDataNotifier!.choices[widget.index] == i
                                      ? MaterialStateProperty.all(
                                          Colors.lightGreenAccent)
                                      : null,
                            ),
                            child: Text(widget.options[i]),
                          ),
                        if (widget.otherButtons != null)
                          ...widget.otherButtons!.map((buttonName) {
                            return SizedBox(
                                width: 20,
                                child: ElevatedButton(
                                    onPressed: () {}, child: Text(buttonName)));
                          }).toList()
                      ],
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
