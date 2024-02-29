import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/user_notifier.dart';
import '../../Utils/debug_utils.dart';

class DOBPage extends StatelessWidget {
  const DOBPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(builder: (context, notifier, child) {
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
                      Text('What\'s your Date of Birth?',
                          style: TextStyle(fontSize: 24)),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _selectDate(context, notifier),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 22.0,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                notifier.dateOfBirth != null
                                    ? '${notifier.dateOfBirth!.day}/${notifier.dateOfBirth!.month}/${notifier.dateOfBirth!.year}'
                                    : 'Select DOB',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
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
    });
  }

  Future<void> _selectDate(
      BuildContext context, UserDataProvider notifier) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: notifier.dateOfBirth ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('en', 'US'),
    );

    if (pickedDate != null && pickedDate != notifier.dateOfBirth) {
      final DateTime currentDate = DateTime.now();
      final DateTime minimumDate =
          DateTime(currentDate.year - 18, currentDate.month, currentDate.day);

      if (pickedDate.isAfter(minimumDate)) {
        // Show an error message or handle the case where the selected date is not valid
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Invalid Date'),
            content: Text('You must be at least 18 years old.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Update the date of birth in the notifier
        notifier.setDateOfBirth(pickedDate);

        // Get current user's UID
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final uid = user.uid;
          // Upload DOB to Firestore
          final userDoc =
              FirebaseFirestore.instance.collection('users').doc(uid);
          await userDoc.set(
            {'DOB': pickedDate},
            SetOptions(merge: true),
          );
          DebugUtils.printDebug('DOB added to firestore!');
        } else {
          print('User not logged in');
        }

        // Handle the selected date here
        print('Selected Date: $pickedDate');
      }
    }
  }
}
