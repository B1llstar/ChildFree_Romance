import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utils/debug_utils.dart';

class UserDataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String countryPicked = '';
  // Getters and setters for countryPicked
  String get getCountryPicked => countryPicked;
  set setCountryPicked(String countryPicked) {
    this.countryPicked = countryPicked;
    notifyListeners();
    DebugUtils.printDebug(
        'Notifier country picked value updated to: $countryPicked');
  }

  User? _user;
  Map<String, dynamic>? _userData;
  List<String> _selectedInterests = [];
  String name = '';
  String profilePictureUrl = '';
  bool? signedUpForNewsletter;
  bool hasSolemnlySworn = false;
  // Getters and setters for hasSolemnly Sworn
  bool get getHasSolemnlySworn => hasSolemnlySworn;
  set setHasSolemnlySworn(bool hasSolemnlySworn) {
    this.hasSolemnlySworn = hasSolemnlySworn;
    notifyListeners();
    DebugUtils.printDebug('Updated solemnly sworn to: $hasSolemnlySworn');
  }
  // Getters and Setters

  // Getters and setters for signedUpForNewsletter
  bool? get getSignedUpForNewsletter => signedUpForNewsletter;
  set setSignedUpForNewsletter(bool signedUpForNewsletter) {
    this.signedUpForNewsletter = signedUpForNewsletter;
  }

  DateTime? _dateOfBirth;
  DateTime? get dateOfBirth => _dateOfBirth;
  void setDateOfBirth(DateTime? date) {
    _dateOfBirth = date;
    notifyListeners();
  }

  // Bools
  bool? isSterilized;
  List<int> choices = [
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1
  ];
  List<int> visitedPages = [
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
// Setter for any index within visitedPages
  void setVisitedPageAtIndex(int index, int value) {
    visitedPages[index] = value;
  }

  // Getter
  List<int> get getVisitedPages => visitedPages;
  // Getters and Setters for Choices

  List<int> get getChoices => choices;
  // Change value of index within choices
  void setChoiceAtIndex(int index, int value) {
    choices[index] = value;
  }

  // Getters and setters for profilePictureUrl
  String get getProfilePictureUrl => profilePictureUrl;
  set setProfilePictureUrl(String profilePictureUrl) {
    this.profilePictureUrl = profilePictureUrl;
  }

  bool shouldShowNameNextButton = false;
  // Getters and setters

  bool get getShouldShowNameNextButton => shouldShowNameNextButton;
  set setShouldShowNameNextButton(bool shouldShowNameNextButton) {
    this.shouldShowNameNextButton = shouldShowNameNextButton;
    notifyListeners();
  }

  // Getters and setters for name
  String get getName => name;
  set setName(String name) {
    this.name = name;
    notifyListeners();
  }

  UserDataProvider() {
    _init();
  }

  Future<void> _init() async {
    await _getUserData();
    if (_user != null) {
      _subscribeToUserDataChanges();
      DebugUtils.printDebug('Subscribed to user snapshot');
    }
  }

  Future<void> _getUserData() async {
    DebugUtils.printDebug('Getting user data...');
    try {
      _user = _auth.currentUser;
      if (_user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('users').doc(_user!.uid).get();
        _userData = snapshot.data();
        DebugUtils.printDebug('Got the user!');
      }
    } catch (error) {
      print('Error loading user data: $error');
    }
  }

  void _subscribeToUserDataChanges() {
    _firestore
        .collection('users')
        .doc(_user!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _userData = snapshot.data();
        notifyListeners();
      }
    });
  }

  dynamic getProperty(String property) {
    DebugUtils.printDebug('Getting property: $property');
    if (_userData != null && _userData!.containsKey(property)) {
      DebugUtils.printDebug('Found property: $property');
      return _userData![property];
    }
    return null;
  }

  Future<void> setProperty(String property, dynamic value) async {
    try {
      // Update locally
      _userData?[property] = value;
      notifyListeners();

      // Update in Firestore
      await _firestore.collection('users').doc(_user!.uid).set({
        property: value,
      }, SetOptions(merge: true));
    } catch (error) {
      print('Error setting property $property: $error');
    }
  }

  List<String>? get selectedInterests => _selectedInterests;

  void addToSelectedInterestList(String interest) {
    selectedInterests?.add(interest);

    DebugUtils.printDebug('Added interest: $interest');
    DebugUtils.printDebug('Current list: $selectedInterests');
    notifyListeners();
  }

  void removeFromSelectedInterestList(String interest) {
    selectedInterests?.remove(interest);
    DebugUtils.printDebug('Removed interest: $interest');
    DebugUtils.printDebug('Current list: $selectedInterests');
    notifyListeners();
  }

  Future<void> updateSelectedInterestsInFirestore() async {
    print('Trying to update interests');
    print('Interests: $selectedInterests');
    try {
      await _firestore.collection('users').doc(_user!.uid).set({
        'selectedInterests': selectedInterests,
      }, SetOptions(merge: true));
    } catch (error) {
      print('Error updating selected interests in Firestore: $error');
    }
  }
}
