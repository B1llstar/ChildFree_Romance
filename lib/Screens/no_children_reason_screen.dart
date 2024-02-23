import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';

class NoChildrenReasonScreen extends StatefulWidget {
  @override
  _NoChildrenReasonScreenState createState() => _NoChildrenReasonScreenState();
}

class _NoChildrenReasonScreenState extends State<NoChildrenReasonScreen> {
  late TextEditingController _reasonController;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the initial value from the notifier
    _reasonController = TextEditingController(
      text: Provider.of<ProfileSetupNotifier>(context, listen: false)
          .noChildrenReason,
    );
    _reasonController.addListener(_checkValidity);
  }

  @override
  void dispose() {
    _reasonController.removeListener(_checkValidity);
    _reasonController.dispose();
    super.dispose();
  }

  void _checkValidity() {
    setState(() {
      _isValid = _reasonController.text.length >= 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Children Reason'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "I don't want children because...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Others will see this on your profile',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10), // Adjusted spacing
            Container(
              width: 500, // Match the width from the provided code
              child: TextFormField(
                controller: _reasonController,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'They\'re time-consuming!',
                  border: OutlineInputBorder(),
                  labelText: 'Must be at least 20 characters',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a reason.';
                  }
                  if (value.length < 20) {
                    return 'Reason must be at least 20 characters.';
                  }
                  return null;
                },
                onChanged: (value) {
                  Provider.of<ProfileSetupNotifier>(context, listen: false)
                      .noChildrenReason = value;
                },
              ),
            ),
            SizedBox(height: 20), // Adjusted spacing
            ElevatedButton(
              onPressed: _isValid ? () => _advancePage(context) : null,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  void _advancePage(BuildContext context) {
    Provider.of<ProfileSetupNotifier>(context, listen: false)
        .advancePage(context);
  }
}
