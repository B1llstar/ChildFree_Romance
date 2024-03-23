import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRefactoringService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _backupUsersCollection =
      FirebaseFirestore.instance.collection('backup_users');

  Future<void> setUsersVisibleProperty() async {
    try {
      // Get all users from 'users' collection
      QuerySnapshot usersSnapshot = await _usersCollection.get();

      // Iterate over each user
      for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
        // Get the document ID
        String userId = userSnapshot.id;

        // Update 'visible' property to true
        await _usersCollection.doc(userId).update({
          'visible': true,
        });
      }

      print('Users visibility set to true successfully!');
    } catch (error) {
      print('Error setting users visibility: $error');
    }
  }

  Future<void> updateUserGenderPreferences() async {
    try {
      // Get all users from 'users' collection
      QuerySnapshot usersSnapshot = await _usersCollection.get();

      // Iterate over each user
      for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        // Assuming each document in 'users' collection has a unique ID
        String userId = userSnapshot.id;

        // Check if 'genderToShow' property exists in the document and has a value
        if (userData.containsKey('genderToShow') &&
            userData['genderToShow'] != null) {
          // If 'genderToShow' exists and has a value, set desiredGenderRomance and desiredGenderFriendship to its value
          await _usersCollection.doc(userId).update({
            'desiredGenderRomance': userData['genderToShow'],
            'desiredGenderFriendship': userData['genderToShow'],
          });
        } else {
          // If 'genderToShow' doesn't exist or has no value, set desiredGenderRomance and desiredGenderFriendship to 'Any'
          await _usersCollection.doc(userId).update({
            'desiredGenderRomance': 'Any',
            'desiredGenderFriendship': 'Any',
          });
        }
      }

      print('User gender preferences updated successfully!');
    } catch (error) {
      print('Error updating user gender preferences: $error');
    }
  }

  Future<void> updateUserPrompts() async {
    try {
      // Get all users from 'users' collection
      QuerySnapshot usersSnapshot = await _usersCollection.get();

      // Iterate over each user
      for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
        // Get the document ID
        String userId = userSnapshot.id;

        // Get user data
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        // Ensure 'aboutMe' property exists, if not create it as an empty map

        // Prompt 1: About Me
        String aboutMeData = userData['aboutMe'] ?? '';
        // Update or add 'prompt_1' property
        if (userData['aboutMe'] != null && userData['aboutMe'].isNotEmpty) {
          await _usersCollection.doc(userId).set({
            'prompt_1': {'prompt': 'About Me', 'answer': userData['aboutMe']},
          }, SetOptions(merge: true));
        }

        // Prompt 2: My Dream Match
        String dreamPartnerData = userData['dreamPartner'] ?? '';

        if (userData['dreamPartner'] != null &&
            userData['dreamPartner'].isNotEmpty) {
          await _usersCollection.doc(userId).set({
            'prompt_2': {
              'prompt': 'My Dream Match',
              'answer': dreamPartnerData
            },
          }, SetOptions(merge: true));
        }

        // Prompt 3: Empty Map
        // Update or add 'prompt_3' property as an empty map
        await _usersCollection.doc(userId).update({
          'prompt_3': {},
        });
      }

      print('User prompts updated successfully!');
    } catch (error) {
      print('Error updating user prompts: $error');
    }
  }

  Future<void> initializeGenderProperty() async {
    try {
      // Get all users from 'users' collection
      QuerySnapshot usersSnapshot = await _usersCollection.get();

      // Iterate over each user
      for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
        // Get the document ID
        String userId = userSnapshot.id;

        // Get user data
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        // Determine gender based on desiredGenderRomance
        String desiredGenderRomance = userData['desiredGenderRomance'];
        String gender = desiredGenderRomance == 'Any'
            ? ''
            : desiredGenderRomance == 'Male'
                ? 'Female'
                : 'Male';

        // Update gender property
        await _usersCollection.doc(userId).update({
          'gender': gender,
        });
      }

      print('Gender properties initialized successfully!');
    } catch (error) {
      print('Error initializing gender properties: $error');
    }
  }

  Future<void> setUserIdProperty() async {
    try {
      // Get all users from 'users' collection
      QuerySnapshot usersSnapshot = await _usersCollection.get();

      // Iterate over each user
      for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
        // Get the document ID
        String userId = userSnapshot.id;

        // Set 'userId' property to document ID
        await _usersCollection.doc(userId).set({
          'userId': userId,
        }, SetOptions(merge: true));
      }

      print('User IDs set successfully!');
    } catch (error) {
      print('Error setting user IDs: $error');
    }
  }

  Future<void> updateProfilePictures() async {
    try {
      // Get all users from 'users' collection
      QuerySnapshot usersSnapshot = await _usersCollection.get();

      // Iterate over each user
      for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        // Assuming each document in 'users' collection has a unique ID
        String userId = userSnapshot.id;

        // Check if 'profilePicture' property exists in the document and has a value
        if (userData.containsKey('profilePicture') &&
            userData['profilePicture'] != null) {
          // If 'profilePicture' exists and has a value, create profilePictures list and set profilePictures[0] to that value
          List<String> profilePictures = [userData['profilePicture']];
          await _usersCollection.doc(userId).update({
            'profilePictures': profilePictures,
          });
        } else {
          // If 'profilePicture' doesn't exist or has no value, do nothing
        }
      }

      print('Profile pictures updated successfully!');
    } catch (error) {
      print('Error updating profile pictures: $error');
    }
  }

  Future<void> backupUsers() async {
    try {
      // Get all users from 'users' collection
      QuerySnapshot usersSnapshot = await _usersCollection.get();

      // Iterate over each user and create a duplicate in 'backup_users' collection
      for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
        Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;

        // Assuming each document in 'users' collection has a unique ID
        String userId = userSnapshot.id;

        // Add user data to 'backup_users' collection with the same document ID
        await _backupUsersCollection.doc(userId).set(data);
      }

      print('Backup completed successfully!');
    } catch (error) {
      print('Error backing up users: $error');
    }
  }
}
