import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestUserAdder extends StatefulWidget {
  @override
  _TestUserAdderState createState() => _TestUserAdderState();
}

class _TestUserAdderState extends State<TestUserAdder> {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference testUsersCollection =
      FirebaseFirestore.instance.collection('test_users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Modification Widget'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: modifyUsersAndUpload,
          child: Text('Modify Users and Upload to test_users'),
        ),
      ),
    );
  }

  Future<void> modifyUsersAndUpload() async {
    QuerySnapshot usersSnapshot = await usersCollection.get();

    for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      // Skip users with null profilePicture
      if (userData['profilePicture'] == null ||
          userData['isLookingFor'] == null ||
          userData['genderToShow'] == null) {
        continue;
      }

      Map<String, dynamic> modifiedUserData = {
        ...userData,
        'desiredGenderRomance': '',
        'desiredGenderFriendship': '',
        'gender': '',
      };

      print(userData);

      String genderToShow = userData['genderToShow'];

      String? isLookingFor = userData['isLookingFor'] ?? 'Romance';

      if (isLookingFor == 'Romance') {
        modifiedUserData['desiredGenderRomance'] =
            genderToShow == 'Female' ? 'Female' : 'Male';
        modifiedUserData['gender'] =
            genderToShow == 'Female' ? 'Male' : 'Female';
      } else if (isLookingFor == 'Friendship') {
        modifiedUserData['desiredGenderFriendship'] =
            genderToShow == 'Female' ? 'Female' : 'Male';
        modifiedUserData['gender'] =
            genderToShow == 'Female' ? 'Male' : 'Female';
      } else {
        modifiedUserData['desiredGenderRomance'] = genderToShow ?? '';
        modifiedUserData['desiredGenderFriendship'] = genderToShow ?? '';
        modifiedUserData['gender'] =
            genderToShow == 'Female' ? 'Male' : 'Female';
      }

      // Handle profilePicture property
      if (modifiedUserData.containsKey('profilePicture')) {
        modifiedUserData['profilePictures'] = [
          modifiedUserData['profilePicture']
        ];
        modifiedUserData.remove('profilePicture');
      }

      await testUsersCollection.doc(userSnapshot.id).set(modifiedUserData);
    }

    print('Users modified and uploaded to test_users successfully!');
  }
}
