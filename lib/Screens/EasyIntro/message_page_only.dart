import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  final String title;
  final String description;
  const MessagePage({Key? key, required this.title, required this.description})
      : super(key: key);

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontSize: 26),
                        ),
                      ],
                    ),
                    if (description.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            description,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      )
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
