import 'package:firebase_auth/firebase_auth.dart';

import '../Notifiers/profile_setup_notifier.dart';
import 'firestore_service.dart';

class StartupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final ProfileSetupNotifier _profileSetupNotifier;

  StartupService(this._profileSetupNotifier);

  Future<void> init() async {
    await _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        Map<String, dynamic>? userProfile =
            await _firestoreService.loadUserProfile();
        if (userProfile != null) {
          _assignValues(userProfile);
          print('User profile loaded successfully.');
        } else {
          print('User profile not found.');
        }
      } else {
        print('No user signed in.');
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  void _assignValues(Map<String, dynamic> userProfile) {
    _profileSetupNotifier.smokingPreference = userProfile['smokingPreference'];
    _profileSetupNotifier.drinkingPreference =
        userProfile['drinkingPreference'];
    _profileSetupNotifier.desiredGender = userProfile['desiredGender'];
    _profileSetupNotifier.dateOfBirth = userProfile['dateOfBirth']
        ?.toDate(); // Convert Firebase Timestamp to DateTime
    _profileSetupNotifier.sexualOrientation = userProfile['sexualOrientation'];
    _profileSetupNotifier.sterilizationStatus =
        userProfile['sterilizationStatus'];
    _profileSetupNotifier.longDistancePreference =
        userProfile['longDistancePreference'];
    _profileSetupNotifier.isWillingToRelocate =
        userProfile['isWillingToRelocate'];
    _profileSetupNotifier.ownGender = userProfile['ownGender'];
    _profileSetupNotifier.noChildrenReason = userProfile['noChildrenReason'];
    _profileSetupNotifier.whyImYourDreamPartner =
        userProfile['whyImYourDreamPartner'];
    _profileSetupNotifier.myDesiredPartner = userProfile['myDesiredPartner'];
  }
}
