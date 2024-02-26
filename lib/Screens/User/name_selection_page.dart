import 'package:flutter/material.dart';

import '../../Notifiers/profile_setup_notifier.dart';

class NameInputPage extends StatelessWidget {
  final ProfileSetupNotifier _profileSetupNotifier = ProfileSetupNotifier();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  _profileSetupNotifier.name = name;
                  Navigator.pop(context); // Go back to the previous page
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid name.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
