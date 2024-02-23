import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';

class LongDistancePreferenceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSetupNotifier>(
      builder: (context, notifier, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Long-Distance Preference'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (notifier.longDistancePreference == null ||
                  notifier.showRelocateQuestion == null ||
                  !notifier.showRelocateQuestion)
                LongDistanceInitialCard(
                  onOptionSelected: (bool value) {
                    notifier.longDistancePreference = value;
                    if (value) {
                      notifier.showRelocateQuestion = true;
                    } else {
                      notifier.advancePage(context);
                    }
                  },
                ),
              if (notifier.showRelocateQuestion != null &&
                  notifier.showRelocateQuestion)
                LongDistanceRelocationCard(
                  onRelocationSelected: (bool value) {
                    notifier.isWillingToRelocate = value;
                    notifier.advancePage(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class LongDistanceInitialCard extends StatelessWidget {
  final Function(bool) onOptionSelected;

  const LongDistanceInitialCard({
    required this.onOptionSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Are you open to long-distance?',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          '🌎',
          style: TextStyle(fontSize: 100.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LongDistanceOptionCard(
              title: 'Yes',
              onPressed: () {
                onOptionSelected(true);
              },
              isSelected: true,
            ),
            LongDistanceOptionCard(
              title: 'No',
              onPressed: () {
                onOptionSelected(false);
              },
              isSelected: false,
            ),
          ],
        ),
      ],
    );
  }
}

class LongDistanceRelocationCard extends StatelessWidget {
  final Function(bool) onRelocationSelected;

  const LongDistanceRelocationCard({
    required this.onRelocationSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Are you willing to relocate?',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LongDistanceOptionCard(
              title: 'Yes',
              onPressed: () {
                onRelocationSelected(true);
              },
              isSelected: true,
            ),
            LongDistanceOptionCard(
              title: 'No',
              onPressed: () {
                onRelocationSelected(false);
              },
              isSelected: false,
            ),
          ],
        ),
      ],
    );
  }
}

class LongDistanceOptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;

  const LongDistanceOptionCard({
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
        color: isSelected ? Colors.green : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
