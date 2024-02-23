import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';

class LongDistancePreferenceScreen extends StatefulWidget {
  @override
  _LongDistancePreferenceScreenState createState() =>
      _LongDistancePreferenceScreenState();
}

class _LongDistancePreferenceScreenState
    extends State<LongDistancePreferenceScreen> {
  bool justLoaded = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSetupNotifier>(
      builder: (context, notifier, _) {
        final bool? longDistancePreference = notifier.longDistancePreference;
        final bool? showRelocateQuestion = notifier.showRelocateQuestion;

        return Scaffold(
          appBar: AppBar(
            title: Text('Long-Distance Preference'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (longDistancePreference == null ||
                  showRelocateQuestion == null ||
                  !showRelocateQuestion)
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
              if (showRelocateQuestion != null && showRelocateQuestion)
                LongDistanceRelocationCard(
                  onRelocationSelected: (bool value) {
                    notifier.isWillingToRelocate = value;
                    notifier.advancePage(context);
                    notifier.showRelocateQuestion = false;
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class LongDistanceInitialCard extends StatefulWidget {
  final Function(bool) onOptionSelected;

  const LongDistanceInitialCard({
    required this.onOptionSelected,
    Key? key,
  }) : super(key: key);

  @override
  _LongDistanceInitialCardState createState() =>
      _LongDistanceInitialCardState();
}

class _LongDistanceInitialCardState extends State<LongDistanceInitialCard> {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ProfileSetupNotifier>(context);
    final bool isSelected = notifier.longDistancePreference ?? false;

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
        Image.asset('assets/globe.png', height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LongDistanceOptionCard(
              title: 'Yes',
              onPressed: () {
                widget.onOptionSelected(true);
              },
              isSelected: isSelected,
            ),
            LongDistanceOptionCard(
              title: 'No',
              onPressed: () {
                widget.onOptionSelected(false);
              },
              isSelected: !isSelected,
            ),
          ],
        ),
      ],
    );
  }
}

class LongDistanceRelocationCard extends StatefulWidget {
  final Function(bool) onRelocationSelected;

  const LongDistanceRelocationCard({
    required this.onRelocationSelected,
    Key? key,
  }) : super(key: key);

  @override
  _LongDistanceRelocationCardState createState() =>
      _LongDistanceRelocationCardState();
}

class _LongDistanceRelocationCardState
    extends State<LongDistanceRelocationCard> {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ProfileSetupNotifier>(context);
    final bool isSelected =
        notifier.isWillingToRelocate ?? false; // Assuming a default value

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
                widget.onRelocationSelected(true);
              },
              isSelected: isSelected,
            ),
            LongDistanceOptionCard(
              title: 'No',
              onPressed: () {
                widget.onRelocationSelected(false);
              },
              isSelected: !isSelected,
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
