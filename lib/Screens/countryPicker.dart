import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Notifiers/user_notifier.dart';
import '../../Utils/debug_utils.dart';
import '../Notifiers/all_users_notifier.dart';
import '../main.dart';

class CountryPicker extends StatefulWidget {
  final UserDataProvider userDataNotifier;
  final AllUsersNotifier allUsersNotifier;
  const CountryPicker(
      {Key? key,
      required this.userDataNotifier,
      required this.allUsersNotifier})
      : super(key: key);

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  updateFirestoreToReflectCountryName(String countryPicked) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      userDocRef.set({'country': countryPicked}, SetOptions(merge: true));
    }
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
                    Text('Choose your country!',
                        style: TextStyle(fontSize: 26)),
                    ElevatedButton(
                      onPressed: () {
                        showCountryPicker(
                          context: context,
                          onSelect: (Country country) {
                            updateFirestoreToReflectCountryName(country.name);
                            setState(() {
                              widget.userDataNotifier.countryPicked =
                                  country.name;
                            });
                            DebugUtils.printDebug(
                                'Country picked: ' + country.name);
                          },
                        );
                      },
                      child: Text(widget.userDataNotifier.countryPicked.isEmpty
                          ? 'Start'
                          : widget.userDataNotifier.countryPicked),
                    ),
                    if (widget.userDataNotifier.countryPicked != null &&
                        widget.userDataNotifier.countryPicked.isNotEmpty)
                      ElevatedButton(
                        child: Text('Done'),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                  allUsersNotifier: widget.allUsersNotifier)),
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
