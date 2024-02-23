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

enum Gender { male, female, other }

class ProfileSetupNotifier extends ChangeNotifier {
  SmokingPreference _smokingPreference = SmokingPreference.no;
  DrinkingPreference _drinkingPreference = DrinkingPreference.no;
  DesiredGender _desiredGender = DesiredGender.male;
  DateTime _dateOfBirth = DateTime.now();
  SexualOrientation _sexualOrientation = SexualOrientation.heterosexual;
  SterilizationStatus _sterilizationStatus = SterilizationStatus.no;
  bool _longDistancePreference = false;
  bool _isWillingToRelocate = false;
  int _currentPageIndex = 0;
  bool _showRelocateQuestion = false;
  Gender _ownGender = Gender.male;
  String _noChildrenReason = '';
  String _whyImYourDreamPartner = '';
  String _myDreamPartner = '';

  String get noChildrenReason => _noChildrenReason;
  set noChildrenReason(String value) {
    _noChildrenReason = value;
    notifyListeners();
  }

  SmokingPreference get smokingPreference => _smokingPreference;
  DrinkingPreference get drinkingPreference => _drinkingPreference;
  DesiredGender get desiredGender => _desiredGender;
  DateTime get dateOfBirth => _dateOfBirth;
  SexualOrientation get sexualOrientation => _sexualOrientation;
  SterilizationStatus get sterilizationStatus => _sterilizationStatus;
  bool get longDistancePreference => _longDistancePreference;
  bool get isWillingToRelocate => _isWillingToRelocate;
  int get currentPageIndex => _currentPageIndex;
  bool get showRelocateQuestion => _showRelocateQuestion;
  Gender get ownGender => _ownGender;

  String get whyImYourDreamPartner => _whyImYourDreamPartner;
  set whyImYourDreamPartner(String value) {
    _whyImYourDreamPartner = value;
    notifyListeners();
  }

  List<String> buttonNames = [
    'Welcome',
    'Gender',
    // 'Sexuality',
    'Sterilization',
    'Smoke',
    'Interests',
    'DOB',
    'Long Distance',
    'Sterilization Status', // Add the new button name
    'Reason',
    'Dream Partner'
  ];

  late PageController _pageController;

  ProfileSetupNotifier() {
    _pageController = PageController();
  }

  PageController get pageController => _pageController;

  void nextPage() {
    if (_pageController.page! < buttonNames.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String get myDesiredPartner => _myDreamPartner;
  set myDesiredPartner(String value) {
    _myDreamPartner = value;
    notifyListeners();
  }

  set showRelocateQuestion(bool value) {
    _showRelocateQuestion = value;
    notifyListeners();
  }

  set smokingPreference(SmokingPreference value) {
    _smokingPreference = value;
    notifyListeners();
  }

  set drinkingPreference(DrinkingPreference value) {
    _drinkingPreference = value;
    notifyListeners();
  }

  set desiredGender(DesiredGender value) {
    _desiredGender = value;
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

  set longDistancePreference(bool value) {
    _longDistancePreference = value;
    notifyListeners();
  }

  set isWillingToRelocate(bool value) {
    _isWillingToRelocate = value;
    notifyListeners();
  }

  void setOwnGender(Gender value) {
    _ownGender = value;
    notifyListeners();
  }

  void setDesiredGender(DesiredGender value) {
    _desiredGender = value;
    notifyListeners();
  }

  void setCurrentPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void advancePage(BuildContext context) {
    _currentPageIndex++;
    nextPage();
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

  void clearAllValues() {
    _smokingPreference = SmokingPreference.no;
    _drinkingPreference = DrinkingPreference.no;
    _desiredGender = DesiredGender.male;
    _dateOfBirth = DateTime.now();
    _sexualOrientation = SexualOrientation.heterosexual;
    _sterilizationStatus = SterilizationStatus.no;
    _longDistancePreference = false;
    _isWillingToRelocate = false;
    _currentPageIndex = 0;
    _showRelocateQuestion = false;
    _whyImYourDreamPartner = '';
    _myDreamPartner = '';
    notifyListeners();
  }
}
