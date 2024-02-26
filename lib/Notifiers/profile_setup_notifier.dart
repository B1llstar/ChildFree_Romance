import 'package:flutter/material.dart';

import '../Services/firestore_service.dart';
import '../Services/http_service.dart';

class ProfileSetupNotifier extends ChangeNotifier {
  String? _smokingPreference;
  String? _profilePicture;
  String? _drinkingPreference;
  String? _desiredGender;
  DateTime? _dateOfBirth;
  String? _sexualOrientation;
  HTTPService _httpService = HTTPService();
  String? _sterilizationStatus;
  bool? _longDistancePreference;
  bool? _isWillingToRelocate;
  int _currentPageIndex = 0;
  bool? _showRelocateQuestion;
  String? _ownGender;
  String? _noChildrenReason = '';
  String? _whyImYourDreamPartner = '';
  String? _myDreamPartner = '';
  String? _name = '';
  String? get name => _name;
  set name(String? value) {
    _name = value;
  }

  bool hasSolemnlySwore = false;
  bool get hasSolemnlySworeValue => hasSolemnlySwore;
  set hasSolemnlySworeValue(bool value) {
    hasSolemnlySwore = value;
    notifyListeners();
  }

  String? get profilePicture => _profilePicture;

  set profilePicture(String? value) {
    _profilePicture = value;
    notifyListeners();
  }

  String? get noChildrenReason => _noChildrenReason;
  set noChildrenReason(String? value) {
    _noChildrenReason = value;
    notifyListeners();
  }

  String? get smokingPreference => _smokingPreference;
  String? get drinkingPreference => _drinkingPreference;
  String? get desiredGender => _desiredGender;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get sexualOrientation => _sexualOrientation;
  String? get sterilizationStatus => _sterilizationStatus;
  bool? get longDistancePreference => _longDistancePreference;
  bool? get isWillingToRelocate => _isWillingToRelocate;
  int get currentPageIndex => _currentPageIndex;
  bool? get showRelocateQuestion => _showRelocateQuestion;
  String? get ownGender => _ownGender;

  set ownGender(String? value) {
    _ownGender = value;
    notifyListeners();
  }

  String? get whyImYourDreamPartner => _whyImYourDreamPartner;
  set whyImYourDreamPartner(String? value) {
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

  void setDateOfBirth(DateTime? date) {
    _dateOfBirth = date;
    notifyListeners();
  }

  void uploadUser() {
    // Call the Firestore upload method here
    FirestoreService firestoreService = FirestoreService();
    Map<String, dynamic> userData = toJson();
    firestoreService.uploadUserData(userData);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'smokingPreference': _smokingPreference,
      'drinkingPreference': _drinkingPreference,
      'desiredGender': _desiredGender,
      'dateOfBirth': _dateOfBirth?.toIso8601String(),
      'sterilizationStatus': _sterilizationStatus,
      'noChildrenReason': _noChildrenReason,
      'whyImYourDreamPartner': _whyImYourDreamPartner,
      'longDistancePreference': _longDistancePreference,
      'isWillingToRelocate': _isWillingToRelocate,
      'ownGender': _ownGender,
      'hasSolemnlySwore': hasSolemnlySwore,
      'profilePicture': profilePicture
    };
  }

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

  String? get myDesiredPartner => _myDreamPartner;
  set myDesiredPartner(String? value) {
    _myDreamPartner = value;
    notifyListeners();
  }

  set showRelocateQuestion(bool? value) {
    _showRelocateQuestion = value;
    notifyListeners();
  }

  set smokingPreference(String? value) {
    _smokingPreference = value;
    notifyListeners();
  }

  set drinkingPreference(String? value) {
    _drinkingPreference = value;
    notifyListeners();
  }

  set desiredGender(String? value) {
    _desiredGender = value;
    notifyListeners();
  }

  set dateOfBirth(DateTime? value) {
    _dateOfBirth = value;
    notifyListeners();
  }

  set sexualOrientation(String? value) {
    _sexualOrientation = value;
    notifyListeners();
  }

  set sterilizationStatus(String? value) {
    _sterilizationStatus = value;
    notifyListeners();
  }

  set longDistancePreference(bool? value) {
    _longDistancePreference = value;
    notifyListeners();
  }

  set isWillingToRelocate(bool? value) {
    _isWillingToRelocate = value;
    notifyListeners();
  }

  void setOwnGender(String? value) {
    _ownGender = value;
    notifyListeners();
  }

  void setCurrentPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void advancePage(BuildContext context) {
    _currentPageIndex = _currentPageIndex + 1;
    nextPage();
    notifyListeners();
    // Additional logic for navigating to the next page can be added here
  }

  void moveBackPage(BuildContext context) {
    if (_currentPageIndex > 0) {
      _currentPageIndex = _currentPageIndex - 1;
      notifyListeners();
      // Additional logic for navigating back to the previous page can be added here
    }
  }

  bool isAtLeast18YearsOld() {
    final DateTime now = DateTime.now();
    final DateTime currentDob =
        _dateOfBirth ?? DateTime.now(); // Capture the current value
    final DateTime minimumDate = DateTime(now.year - 18, now.month, now.day);
    return currentDob.isBefore(minimumDate) ||
        currentDob.isAtSameMomentAs(minimumDate);
  }

  void clearAllValues() {
    _smokingPreference = null;
    _drinkingPreference = null;
    _desiredGender = null;
    _dateOfBirth = null;
    _sexualOrientation = null;
    _sterilizationStatus = null;
    _longDistancePreference = null;
    _isWillingToRelocate = null;
    _currentPageIndex = 0;
    _showRelocateQuestion = null;
    _whyImYourDreamPartner = '';
    _myDreamPartner = '';
    _noChildrenReason = '';
    notifyListeners();
  }

  Future<String> generateAITextForProperty(
      String property, int maxTokens) async {
    // Start building the description string
    String description =
        'You are an assistant tasked with helping a user create a dating profile. Your purpose is to fill in the gaps of their application when it\'s asked of you, based on the information the user provides. Anything created will reflect the general sentiment of the user\'s existing information, if any.\nHere are the properties of the user\'s profile:\n\n';

    // Get all properties from toJson method
    Map<String, dynamic> profile = toJson();

    // Iterate over the properties and add them to the description
    profile.forEach((key, value) {
      description += '$key: $value\n';
    });

    String response =
        await _httpService.makeRequest(property, description, 500);
    return response;
  }
}
