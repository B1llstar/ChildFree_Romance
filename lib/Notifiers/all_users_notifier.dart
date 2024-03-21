// TODO: Update user collection for production (right now it's testing only)

import 'package:childfree_romance/Services/reverse_geocode_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllUsersNotifier extends ChangeNotifier {
  List<Map<String, dynamic>> _profiles = [];
  Map<String, dynamic> _currentUser = {};
  List<String> _profilePictures = [];

  List<Map<String, dynamic>> get profiles => _profiles;
  Map<String, dynamic> get currentUser => _currentUser;
  List<String> get profilePictures => _profilePictures;
  String uid = '';
  ReverseGeocodeService? _reverseGeocodeService;
  List<String> _matchIds = [];
  List<String> _matchProfilePictures = [];
  List<dynamic> _prompts = [];

  // getters and setters
  List<String> get matchIds => _matchIds;
  Map<String, dynamic> _prompt_1 = {};
  Map<String, dynamic> _prompt_2 = {};
  Map<String, dynamic> _prompt_3 = {};
  Map<String, dynamic> get prompt_1 => prompt_1;
  Map<String, dynamic> get prompt_2 => prompt_2;
  Map<String, dynamic> get prompt_3 => prompt_3;
  bool _visibility = false;
  bool get visibility => _visibility;
  bool _canShow = false;
  bool get canShow => _canShow;
  set canShow(bool value) {
    _canShow = value;
    notifyListeners();
  }

  set visibility(bool value) {
    _visibility = value;
    notifyListeners();
  }

  List<String> _selectedInterests = [];
  List<String> get selectedInterests => _selectedInterests;
  List<String> get matchProfilePictures => _matchProfilePictures;
  bool _darkMode = false;
  bool get darkMode => _darkMode;
// Setter
  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  final userCollection = FirebaseFirestore.instance.collection('test_users');
  init(String userId) async {
    await fetchCurrentUser(userId);
    await fetchProfilesExcludingUser(userId, true);
    await loadProfilePictures();
    await loadInterests();
    print('Init called...');
    uid = userId;
    _reverseGeocodeService = ReverseGeocodeService(uid);
//    await fetchMatches();
    notifyListeners();
  }

  // Setter for selectedInterests
  void setSelectedInterests(List<String> selectedInterests) async {
    _selectedInterests = selectedInterests;
    await updateSelectedInterestsInFirestore();
    print('Updationg Firestore');
    notifyListeners();
  }

  Future<void> checkToSeeIfTheyHaveEnoughToShowTheirProfile() async {
    try {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('test_users')
          .doc(_currentUser['userId'])
          .get();

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> prompt =
          userData['prompt_1'] ?? ''; // Assuming 'prompt_1' is a String
      List<dynamic> profilePictures = userData['profilePictures'] ?? [];
      print(userData);
      String gender = userData['gender'] ?? ''; // Assuming 'gender' is a String
      print('Prompt 1: $prompt');
      print('Profile Pictures: $profilePictures');
      print('Gender: $gender');
      bool promptIsAcceptable = prompt.isNotEmpty &&
          prompt.containsKey('prompt') &&
          prompt.containsKey('answer') &&
          prompt['prompt'] != null &&
          prompt['prompt'].isNotEmpty &&
          prompt['answer'] != null &&
          prompt['answer'].isNotEmpty;
      print('Prompt is acceptable: $promptIsAcceptable');

      if (promptIsAcceptable &&
          profilePictures.isNotEmpty &&
          gender.isNotEmpty) {
        _canShow = true;

        notifyListeners();
      } else {
        _canShow = false;
        visibility = false;
        onlyChangeUserVisibility(_currentUser['userId'], false);
        notifyListeners();
      }
    } catch (error) {
      print('Error fetching user data: $error');
      // Handle error as needed
    }
  }

  Future<void> onlyChangeUserVisibility(String userId, bool isVisible) async {
    try {
      await FirebaseFirestore.instance
          .collection('test_users')
          .doc(userId)
          .set({
        'visible': isVisible,
      }, SetOptions(merge: true));
      print('User visibility updated successfully');
    } catch (error) {
      print('Error updating user visibility: $error');
      // Handle error as needed
    }
  }

  Future<void> changeUserVisibilityOrShowDialog(
      String userId, bool isVisible, BuildContext context) async {
    try {
      await checkToSeeIfTheyHaveEnoughToShowTheirProfile(); // Wait for the async check to complete
      if (canShow) {
        visibility = isVisible;
        notifyListeners();
        await FirebaseFirestore.instance
            .collection('test_users')
            .doc(userId)
            .set({
          'visible': isVisible,
        }, SetOptions(merge: true));
        print('User visibility updated successfully');
      } else {
        // Show an Alert Dialog
        print('User does not have enough information to show their profile');
        // Show AlertDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Please fill out all of the required fields!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please provide more information to show your profile:',
                  ),
                  SizedBox(height: 8),
                  Text('- One prompt'),
                  Text('- One profile picture'),
                  Text('- Gender'),
                  Text(
                      'For your convenience, these fields are marked with asterisks (*)!'),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error updating user visibility: $error');
      // Handle error as needed
    }
  }

  String getAddressStringFromGeocodingService() {
    print('Service is null ? ${_reverseGeocodeService == null}');
    if (_reverseGeocodeService != null) {
      return _reverseGeocodeService!.getAddressString();
    } else {
      return ' ';
    }
  }

  Future<void> fetchMatches() async {
    try {
      print('Fetching matches...');
      // Fetch matches from Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('matches')
          .where('userIds', arrayContains: _currentUser['userId'])
          .get();

      // Extract userIds from documents and filter out current user's id
      final List<String> allUserIds = [];
      querySnapshot.docs.forEach((doc) {
        final List<String> userIds = List<String>.from(doc['userIds']);
        allUserIds.addAll(userIds);
      });
      _matchIds = allUserIds.toSet().toList(); // Remove duplicates
      _matchIds.remove(_currentUser['userId']); // Remove current user's id

      print('Unique match ids: $_matchIds');
      // Fetch profile pictures of matches
      await fetchMatchProfilePictures();
    } catch (error) {
      print('Failed to fetch matches: $error');
    }
  }

  Future<void> fetchMatchProfilePictures() async {
    try {
      _matchProfilePictures = []; // Clear existing match profile pictures

      // Iterate through each match ID
      for (String matchId in _matchIds) {
        // Filter profiles to find the one with matching userId
        final List<Map<String, dynamic>> matchingProfiles =
            _profiles.where((profile) => profile['userId'] == matchId).toList();

        // If matching profile is found
        if (matchingProfiles.isNotEmpty) {
          final String userId = matchingProfiles[0]['userId'];

          // Check if profilePictures is not a property or if it's null or empty
          if (matchingProfiles[0]['profilePictures'] == null ||
              (matchingProfiles[0]['profilePictures'] as List).isEmpty) {
            _matchProfilePictures.add(
                'https://static.wikia.nocookie.net/shingekinokyojin/images/3/3c/Eren_Jaeger_%28Anime%29_character_image_%28850%29.png/revision/latest/scale-to-width/360?cb=20201228000236');
          } else {
            _matchProfilePictures
                .add(matchingProfiles[0]['profilePictures'][0]);
          }
        }
      }
      print(_matchProfilePictures.length);
      notifyListeners();
    } catch (error) {
      print('Failed to fetch match profile pictures: $error');
    }
  }

  fetchCurrentUser(String userId) async {
    print('Fetching current user profile...');
    await FirebaseFirestore.instance
        .collection('test_users')
        .doc(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        _currentUser = (doc.data() as Map<String, dynamic>)..remove('email');
        _prompt_1 = _currentUser['prompt_1'] ?? {};
        _prompt_2 = _currentUser['prompt_2'] ?? {};
        _prompt_3 = _currentUser['prompt_3'] ?? {};
        _visibility =
            _currentUser['visible'] ?? false; // All users start  as false
        print('Prompts: $_prompt_1, $_prompt_2, $_prompt_3');
        notifyListeners();
      } else {
        print('User profile not found');
      }
    }).catchError((error) {
      print("Failed to fetch current user profile: $error");
    });
  }

  String getProfilePictureForUserId(String userId) {
    for (var profile in _profiles) {
      if (profile['userId'] == userId) {
        print('Found the user');
      }
    }
    return 'placeholder';
  }

  fetchProfilesExcludingUser(String userId, bool testing) async {
    String collectionPath = testing ? 'test_users' : 'users';
    print('Fetching profiles...');
    FirebaseFirestore.instance
        .collection(collectionPath)
        .get()
        .then((querySnapshot) {
      _profiles = querySnapshot.docs
          .where((doc) => doc.id != userId) // Filter out the current user
          .map((doc) => (doc.data() as Map<String, dynamic>)..remove('email'))
          .toList();
      notifyListeners();
    }).catchError((error) {
      print("Failed to fetch profiles: $error");
    });
  }

  loadProfilePictures() {
    _profilePictures = _currentUser['profilePictures'] != null
        ? List<String>.from(_currentUser['profilePictures'])
        : [];
    notifyListeners();
  }

  loadInterests() {
    _selectedInterests = _currentUser['selectedInterests'] != null
        ? List<String>.from(_currentUser['selectedInterests'])
        : [];
    notifyListeners();
    print('Interests are: $_selectedInterests');
  }

  updateSelectedInterestsInFirestore() async {
    await userCollection.doc(_currentUser['userId']).set(
        {'selectedInterests': _selectedInterests}, SetOptions(merge: true));
  }

  convertIsLookingForToCardString(Map<String, dynamic> profile) {
    if (profile['isLookingFor'] == 'Romance') {
      return 'Romance';
    } else if (profile['isLookingFor'] == 'Friendship') {
      return 'Friendship';
    } else if (profile['isLookingFor'] == 'Both') {
      return 'Romance & Friendship';
    } else {
      return 'N\\A';
    }
  }

  fetchHardcodedProfiles() {
    // Simulating fetching hardcoded profiles
    print('Fetching hardcoded profiles...');
    // Replace this with your actual hardcoded profiles
    _profiles = [
      {
        'name': 'Bill',
        'userId': '123',
        'age': 27,
        'isLookingFor': 'Friendship',
        'gender': 'Male',
        'desiredGenderFriendship': 'Male',
        'aboutMe': 'Fun & adventurous',
        'profilePictures': [
          'https://media.discordapp.net/attachments/1213940158169096213/1213940631018274967/Screenshot_20230711_121308_Gallery.jpg?ex=65f74d50&is=65e4d850&hm=a4a67e504c13fac45825e27bb285795b3c2fa43083ee4194b25a7e381ca3cdca&=&format=webp&width=304&height=537'
        ],
        'selectedInterests': ['Video Games', 'Cooking'],
        'locale': {
          'city': 'New York',
          'state': 'New York',
          'country': 'United States',
          'countryCode': 'US'
        }
      },
      {
        'isLookingFor': 'Both',
        'desiredGenderRomance': 'Any',
        'desiredGenderFriendship': 'Male',
        'name': 'Bacon',
        'userId': '1234',
        'gender': 'Female',
        'age': 22,
        'aboutMe': 'Crigne',
        'profilePictures': [
          'https://media.istockphoto.com/id/508755080/photo/cooked-bacon-rashers-close-up-isolated-on-a-white-background.jpg?s=612x612&w=0&k=20&c=XLmDH3d2J50Q1y7rufm9VE6Q_o8p7-0MY_e2NFTa6lA='
        ],
        'selectedInterests': ['Video Games', 'Cooking'],
        'locale': {
          'city': 'Quebec',
          'state': 'Canada',
          'country': 'United States',
          'countryCode': 'US'
        }
      },
      {
        'isLookingFor': 'Romance',
        'name': 'Jeremy',
        'desiredGenderRomance': 'Any',
        'desiredGenderFriendship': 'Any',
        'gender': 'Female',
        'userId': '12345',
        'age': 28,
        'aboutMe': 'Brother of crigne',
        'profilePictures': [
          'https://media.istockphoto.com/id/108224580/photo/frenchman-with-french-baguettes.jpg?s=612x612&w=0&k=20&c=8YDn27Q1d7xaVayJfWXGymjbbbMDGgKaLq0XAmNqNSI='
        ],
        'selectedInterests': ['Video Games', 'Cooking'],
        'locale': {
          'city': 'New York',
          'state': 'New York',
          'country': 'United States',
          'countryCode': 'US'
        }
      }
    ];

    notifyListeners();
  }

  Future<void> addProfilePicture(String userId, String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('test_users')
          .doc(userId)
          .update({
        'profilePictures': FieldValue.arrayUnion([imageUrl])
      });
      _profilePictures.add(imageUrl);
      notifyListeners();
    } catch (error) {
      print("Failed to add profile picture: $error");
    }
  }

  Future<void> uploadProfilePictureAtIndex(int index, String imageUrl) async {
    try {
      // Create a copy of the current profile pictures list
      List<String> updatedProfilePictures = List.from(_profilePictures);
      if (index >= 0 && index <= _profilePictures.length) {
        // Remove the item at the specified index, if it exists
        if (index < updatedProfilePictures.length) {
          updatedProfilePictures.removeAt(index);
        }
        // Insert the new image URL at the specified index
        updatedProfilePictures.insert(index, imageUrl);
        // Update Firestore with the new list of profile pictures
        await FirebaseFirestore.instance
            .collection('test_users')
            .doc(uid)
            .update({
          'profilePictures': updatedProfilePictures,
        });
        // Update local state with the updated profile pictures list
        _profilePictures = updatedProfilePictures;
        notifyListeners();
      } else {
        print("Invalid index");
      }
    } catch (error) {
      print("Failed to upload profile picture: $error");
    }
  }

  void swapProfilePictures(int index1, int index2) async {
    if (index1 >= 0 &&
        index2 >= 0 &&
        index1 < _profilePictures.length &&
        index2 < _profilePictures.length &&
        index1 != index2) {
      final temp = _profilePictures[index1];
      _profilePictures[index1] = _profilePictures[index2];
      _profilePictures[index2] = temp;
      notifyListeners();

      try {
        await FirebaseFirestore.instance
            .collection('test_users')
            .doc(uid)
            .update({
          'profilePictures': _profilePictures,
        });
        print('Successfully updated images');
      } catch (error) {
        print("Failed to update profile pictures in Firestore: $error");
        // Revert changes if update fails
        final temp = _profilePictures[index1];
        _profilePictures[index1] = _profilePictures[index2];
        _profilePictures[index2] = temp;
        notifyListeners();
      }
    }
  }

  Future<void> deleteProfilePicture(int index) async {
    try {
      // Remove the image URL from the local list
      if (index >= 0 && index < _profilePictures.length) {
        _profilePictures.removeAt(index);
        notifyListeners();

        // Update Firestore with the updated list of profile pictures
        await FirebaseFirestore.instance
            .collection('test_users')
            .doc(uid)
            .update({
          'profilePictures': _profilePictures,
        });
        print('Successfully deleted image at index $index');
        await checkToSeeIfTheyHaveEnoughToShowTheirProfile();
      } else {
        print('Invalid index');
      }
    } catch (error) {
      print('Failed to delete profile picture: $error');
    }
  }
}
