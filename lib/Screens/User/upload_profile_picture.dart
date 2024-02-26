import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

import '../../Notifiers/user_notifier.dart';

class ProfilePictureUpload extends StatefulWidget {
  final VoidCallback? onNextPressed;

  const ProfilePictureUpload({Key? key, this.onNextPressed}) : super(key: key);

  @override
  _ProfilePictureUploadState createState() => _ProfilePictureUploadState();
}

class _ProfilePictureUploadState extends State<ProfilePictureUpload> {
  UserDataProvider? _userDataProvider;
  Uint8List? _imageBytes;
  String profilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    _userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    _loadExistingPicture();
  }

  Future<void> _uploadPicture(Uint8List imageBytes, String fileName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        Reference storageReference = FirebaseStorage.instance
            .ref('users/$userId/profile_pictures/$fileName');

        await storageReference.putData(imageBytes);

        profilePictureUrl = await storageReference.getDownloadURL();
        await _userDataProvider!
            .setProperty('profilePicture', profilePictureUrl);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile picture uploaded successfully!'),
        ));

        _loadExistingPicture();
      } else {
        print('No user signed in.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user signed in!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload profile picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadExistingPicture() async {
    profilePictureUrl = _userDataProvider!.getProperty('profilePicture') ?? '';

    if (profilePictureUrl.isNotEmpty) {
      try {
        Uint8List? bytes;

        if (!kIsWeb) {
          bytes = await FirebaseStorage.instance
              .refFromURL(profilePictureUrl)
              .getData();
        }

        setState(() {
          _imageBytes = bytes;
        });
      } catch (e) {
        print('Error loading existing profile picture: $e');
      }
    }
  }

  void _selectPicture() async {
    if (kIsWeb) {
      html.InputElement uploadInput = html.FileUploadInputElement();
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files?.length == 1) {
          final file = files?[0];
          final reader = html.FileReader();

          reader.onLoadEnd.listen((e) {
            setState(() {
              _imageBytes = reader.result as Uint8List?;
              print("Image loaded!");
            });
          });

          reader.onError.listen((fileEvent) {
            setState(() {
              print("Error reading file");
            });
          });

          reader.readAsArrayBuffer(file!);
          final fileName = Path.basename(file.name);
          await _uploadPicture(_imageBytes!, fileName);
        }
      });
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        _uploadPicture(result.files.single.bytes!,
            Path.basename(result.files.single.name!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userDataProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Upload Profile Picture'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: _buildProfilePicture(),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _selectPicture,
                  child: Text('Select Picture'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 200,
      height: 200,
      child: _imageBytes != null
          ? Image.memory(
              _imageBytes!,
              fit: BoxFit.cover,
            )
          : Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[300],
            ),
    );
  }
}
