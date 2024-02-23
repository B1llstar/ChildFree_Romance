import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Notifiers/profile_setup_notifier.dart';

class DreamPartnerScreen extends StatefulWidget {
  DreamPartnerScreen({Key? key}) : super(key: key);

  @override
  _DreamPartnerScreenState createState() => _DreamPartnerScreenState();
}

class _DreamPartnerScreenState extends State<DreamPartnerScreen> {
  int _currentIndex = 0;
  late TextEditingController _textEditingController;
  late ProfileSetupNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _notifier = Provider.of<ProfileSetupNotifier>(context, listen: false);

    if (_currentIndex == 0 && _notifier.whyImYourDreamPartner != null) {
      _textEditingController.text = _notifier.whyImYourDreamPartner!;
    } else if (_currentIndex == 1 && _notifier.myDesiredPartner != null) {
      _textEditingController.text = _notifier.myDesiredPartner!;
    }
  }

  void goToNext() {
    setState(() {
      if (_currentIndex == 1) _notifier.advancePage(context);

      _currentIndex++;

      if (_currentIndex == 0 && _notifier.whyImYourDreamPartner != null) {
        _textEditingController.text = _notifier.whyImYourDreamPartner!;
      } else if (_currentIndex == 1 && _notifier.myDesiredPartner != null) {
        _textEditingController.text = _notifier.myDesiredPartner!;
      }
    });
  }

  void goToPrevious() {
    setState(() {
      _currentIndex--;

      if (_currentIndex == 0 && _notifier.whyImYourDreamPartner != null) {
        _textEditingController.text = _notifier.whyImYourDreamPartner!;
      } else if (_currentIndex == 1 && _notifier.myDesiredPartner != null) {
        _textEditingController.text = _notifier.myDesiredPartner!;
      }
    });
  }

  bool isNextButtonEnabled() {
    if (_currentIndex == 0) {
      return _textEditingController.text.length >= 20;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dream Partner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentIndex == 0
                      ? 'I\'m your dream partner because...'
                      : 'My dream partner would be...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*
                  Text(
                    _currentIndex == 0
                        ? 'I am your dream partner because...'
                        : 'My dream partner is...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),*/
                  SizedBox(height: 10),
                  Container(
                    width: 500,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if (value != null &&
                            value.isNotEmpty &&
                            value.length < 20) {
                          return 'Please enter at least 20 characters (${value.length})';
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _textEditingController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: _currentIndex == 0
                            ? 'I am kind, patient, and loving.'
                            : 'someone kind, loyal, and intelligent. (min. length 20)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (_currentIndex == 0) {
                          _notifier.whyImYourDreamPartner = value;
                        } else {
                          _notifier.myDesiredPartner = value;
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _currentIndex == 0 ? null : goToPrevious,
                  child: Text('Prev'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: isNextButtonEnabled() ? goToNext : null,
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
