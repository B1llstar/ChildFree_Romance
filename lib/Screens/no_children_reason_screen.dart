import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';

class NoChildrenReasonScreen extends StatefulWidget {
  @override
  _NoChildrenReasonScreenState createState() => _NoChildrenReasonScreenState();
}

class _NoChildrenReasonScreenState extends State<NoChildrenReasonScreen> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
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
      body: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                child: TextFormField(
                  controller: _reasonController,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText:
                        'They\'re expensive, time-consuming, or an all-around nuisance.',
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
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isValid ? () => _advancePage(context) : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  void _advancePage(BuildContext context) {
    Provider.of<ProfileSetupNotifier>(context, listen: false)
        .advancePage(context);
  }
}
