import 'package:flutter/material.dart';

enum SmokingPreference { yes, no, socially }

enum DrinkingPreference { yes, no, socially }

enum DesiredGender { male, female, any }

enum SexualOrientation {
  heterosexual,
  homosexual,
  bisexual,
  pansexual,
  asexual,
  other
}

enum SterilizationStatus { yes, no }

class ProfileSetupNotifier extends ChangeNotifier {
  SmokingPreference _smokingPreference = SmokingPreference.no;
  DrinkingPreference _drinkingPreference = DrinkingPreference.no;
  DesiredGender _genderIdentity = DesiredGender.male;
  DateTime _dateOfBirth = DateTime.now();
  SexualOrientation _sexualOrientation = SexualOrientation.heterosexual;
  SterilizationStatus _sterilizationStatus = SterilizationStatus.no;
  int _currentPageIndex = 0;

  // Getters
  SmokingPreference get smokingPreference => _smokingPreference;
  DrinkingPreference get drinkingPreference => _drinkingPreference;
  DesiredGender get genderIdentity => _genderIdentity;
  DateTime get dateOfBirth => _dateOfBirth;
  SexualOrientation get sexualOrientation => _sexualOrientation;
  SterilizationStatus get sterilizationStatus => _sterilizationStatus;
  int get currentPageIndex => _currentPageIndex;

  // Setters
  set smokingPreference(SmokingPreference value) {
    _smokingPreference = value;
    notifyListeners();
  }

  set drinkingPreference(DrinkingPreference value) {
    _drinkingPreference = value;
    notifyListeners();
  }

  set genderIdentity(DesiredGender value) {
    _genderIdentity = value;
    notifyListeners();
  }

  set dateOfBirth(DateTime value) {
    _dateOfBirth = value;
    notifyListeners();
  }

  set sexualOrientation(SexualOrientation value) {
    _sexualOrientation = value;
    notifyListeners();
  }

  set sterilizationStatus(SterilizationStatus value) {
    _sterilizationStatus = value;
    notifyListeners();
  }

  // Methods to navigate pages
  void setCurrentPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void advancePage(BuildContext context) {
    _currentPageIndex++;
    notifyListeners();
    // Additional logic for navigating to the next page can be added here
  }

  void moveBackPage(BuildContext context) {
    if (_currentPageIndex > 0) {
      _currentPageIndex--;
      notifyListeners();
      // Additional logic for navigating back to the previous page can be added here
    }
  }

  // Method to clear all preferences
  void clearPreferences() {
    _smokingPreference = SmokingPreference.no;
    _drinkingPreference = DrinkingPreference.no;
    _genderIdentity = DesiredGender.male;
    _dateOfBirth = DateTime.now();
    _sexualOrientation = SexualOrientation.heterosexual;
    _sterilizationStatus = SterilizationStatus.no;
    _currentPageIndex = 0;
    notifyListeners();
  }
}
