import 'package:flutter/material.dart';

class DreamPartnerPage extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const DreamPartnerPage(
      {Key? key, required this.controller, required this.onChanged})
      : super(key: key);

  @override
  _DreamPartnerPageState createState() => _DreamPartnerPageState();
}

class _DreamPartnerPageState extends State<DreamPartnerPage> {
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
                    Text(
                      'My perfect match would be...',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 300,
                      child: TextField(
                        controller: widget.controller,
                        decoration: InputDecoration(
                          hintText: 'Friendly, with a good sense of humor!',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          widget.onChanged(value);
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
