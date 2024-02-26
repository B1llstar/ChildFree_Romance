import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String property;
  final String title;
  final String assetImageUrl;
  final List<String> options;
  final void Function(String, String) onButtonPressed;
  final List<String>? otherButtons;

  const QuestionWidget({
    Key? key,
    required this.property,
    required this.title,
    required this.assetImageUrl,
    required this.options,
    required this.onButtonPressed,
    this.otherButtons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      title,
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      assetImageUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var option in options)
                          ElevatedButton(
                            onPressed: () {
                              onButtonPressed(property, option);
                            },
                            child: Text(option),
                          ),
                        if (otherButtons != null)
                          ...otherButtons!.map((buttonName) {
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
