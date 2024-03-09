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

  void init(String userId) async {
    await fetchCurrentUser(userId);
    await fetchHardcodedProfiles();
    await loadProfilePictures();
    print('Init called...');
    uid = userId;
    _reverseGeocodeService = ReverseGeocodeService(uid);
  }

  String getAddressStringFromGeocodingService() {
    print('Service is null ? ${_reverseGeocodeService == null}');
    if (_reverseGeocodeService != null) {
      return _reverseGeocodeService!.getAddressString();
    } else {
      return ' ';
    }
  }

  fetchCurrentUser(String userId) async {
    print('Fetching current user profile...');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        print('User exists!');
        print(doc.data());
        _currentUser = (doc.data() as Map<String, dynamic>)..remove('email');
        notifyListeners();
      } else {
        print('User profile not found');
      }
    }).catchError((error) {
      print("Failed to fetch current user profile: $error");
    });
  }

  fetchProfilesExcludingUser(String userId) {
    print('Fetching profiles...');
    FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
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
    print('Loaded profile pictures.');
    print('Length: ${_profilePictures.length}');
    print('User: ' + _currentUser.toString());
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
        'isLookingFor': 'Both',
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
        'name': 'Bacon',
        'userId': '1234',
        'age': 22,
        'aboutMe': 'Crigne',
        'profilePictures': [
          'https://media.istockphoto.com/id/508755080/photo/cooked-bacon-rashers-close-up-isolated-on-a-white-background.jpg?s=612x612&w=0&k=20&c=XLmDH3d2J50Q1y7rufm9VE6Q_o8p7-0MY_e2NFTa6lA='
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
        'name': 'Cyanide',
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
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
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
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
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
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
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
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profilePictures': _profilePictures,
        });
        print('Successfully deleted image at index $index');
      } else {
        print('Invalid index');
      }
    } catch (error) {
      print('Failed to delete profile picture: $error');
    }
  }
}
