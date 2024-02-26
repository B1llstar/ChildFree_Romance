import 'package:flutter/material.dart';

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  final List<String> interests = [];
  int maxInterests = 3; // Maximum number of interests allowed

  void addInterest() {
    if (interests.length < maxInterests) {
      setState(() {
        interests.add('');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Interests',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: interests.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your interest',
                        labelText: 'Interest ${index + 1}',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        interests[index] = value;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter details about your interest',
                        labelText: 'Details',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                );
              },
            ),
            if (interests.length < maxInterests)
              ElevatedButton(
                onPressed: addInterest,
                child: Text('Add Interest'),
              ),
            ElevatedButton(
              onPressed: () {
                // Handle save button press
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
