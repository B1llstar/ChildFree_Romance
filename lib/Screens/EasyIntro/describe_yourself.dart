import 'package:flutter/material.dart';

class DescribeYourselfPage extends StatefulWidget {
  final TextEditingController controller;

  const DescribeYourselfPage({Key? key, required this.controller})
      : super(key: key);

  @override
  _DescribeYourselfPageState createState() => _DescribeYourselfPageState();
}

class _DescribeYourselfPageState extends State<DescribeYourselfPage> {
  @override
  void initState() {
    super.initState();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 320,
                          child: Text(
                            'I\'m the perfect match because...',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 300,
                      child: TextField(
                        controller: widget.controller,
                        decoration: InputDecoration(
                          hintText: 'I\'m loving, faithful, and adventurous',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {},
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
