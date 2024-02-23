import 'package:flutter/material.dart';

class ChildfreeDeclarationPage extends StatefulWidget {
  @override
  _ChildfreeDeclarationPageState createState() =>
      _ChildfreeDeclarationPageState();
}

class _ChildfreeDeclarationPageState extends State<ChildfreeDeclarationPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Childfree Declaration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: Text(
                "I solemnly swear that I do not have children, and am certain that I will never, EVER want them. Ever. Seriously, my mind is made up.",
                style: TextStyle(fontSize: 16.0),
              ),
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChildfreeDeclarationPage(),
  ));
}
