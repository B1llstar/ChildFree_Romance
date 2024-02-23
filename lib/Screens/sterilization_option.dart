import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';

class SterilizationStatusPage extends StatefulWidget {
  @override
  _SterilizationStatusPageState createState() =>
      _SterilizationStatusPageState();
}

class _SterilizationStatusPageState extends State<SterilizationStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSetupNotifier>(
      builder: (context, notifier, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Sterilization Status'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Have you been sterilized?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '🩺',
                style: TextStyle(fontSize: 100.0),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SterilizationOptionCard(
                    title: 'Yes',
                    onPressed: () {
                      notifier.sterilizationStatus = SterilizationStatus.yes;
                      notifier.advancePage(context);
                    },
                    isSelected:
                        notifier.sterilizationStatus == SterilizationStatus.yes,
                  ),
                  SterilizationOptionCard(
                    title: 'No',
                    onPressed: () {
                      notifier.sterilizationStatus = SterilizationStatus.no;
                      notifier.advancePage(context);
                    },
                    isSelected:
                        notifier.sterilizationStatus == SterilizationStatus.no,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class SterilizationOptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;

  const SterilizationOptionCard({
    required this.title,
    required this.onPressed,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(8.0),
        color:
            isSelected ? Colors.green : null, // Highlight in green if selected
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : Colors.black, // Text color based on selection
            ),
          ),
        ),
      ),
    );
  }
}
