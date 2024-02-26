import 'dart:io' show File;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

class ProfilePictureUpload extends StatefulWidget {
  final VoidCallback onNextPressed;

  const ProfilePictureUpload({Key? key, required this.onNextPressed})
      : super(key: key);

  @override
  _ProfilePictureUploadState createState() => _ProfilePictureUploadState();
}

class _ProfilePictureUploadState extends State<ProfilePictureUpload> {
  Uint8List? uploadedImage;
  String? imageUrl;
  String? errorMessage;
  bool nameValidated = false;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCachedImage();
  }

  Future<void> loadCachedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedImageBase64 = prefs.getString('cachedAvatarImage');
    if (cachedImageBase64 != null) {
      final decodedImage = Uint8List.fromList(
        List<int>.from(cachedImageBase64.codeUnits),
      );
      setState(() {
        uploadedImage = decodedImage;
      });
    }
  }

  Future<void> cacheImage(Uint8List imageBytes) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedImage = String.fromCharCodes(imageBytes);
    prefs.setString('cachedAvatarImage', encodedImage);
  }

  Future<void> uploadAndCacheImage(String uid, Uint8List imageBytes) async {
    try {
      final imageUrl = await _uploadImageToStorage(uid, imageBytes);
      await _updateProfilePicture(uid, imageUrl);
      setState(() {
        this.imageUrl = imageUrl;
      });
      await cacheImage(imageBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image uploaded successfully'),
        ),
      );
    } catch (error) {
      setState(() {
        errorMessage = "Failed to upload image";
      });
    }
  }

  Future<String> _uploadImageToStorage(String uid, Uint8List imageBytes) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference imageReference = storage.ref().child(
        'users/$uid/profile_pictures/${DateTime.now().microsecondsSinceEpoch}.png');

    try {
      // Upload the image bytes
      await imageReference.putData(imageBytes);

      // Get the download URL
      final String imageUrl = await imageReference.getDownloadURL();
      print('Url: $imageUrl');
      return imageUrl;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _updateProfilePicture(String uid, String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'profilePicture': imageUrl}, SetOptions(merge: true));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      if (kIsWeb) {
        final html.FileUploadInputElement uploadInput =
            html.FileUploadInputElement();
        uploadInput.click();

        uploadInput.onChange.listen((e) async {
          // Read file content as dataURL
          final files = uploadInput.files;
          if (files?.length == 1) {
            final file = files?[0];
            final reader = html.FileReader();

            reader.onLoadEnd.listen((e) async {
              setState(() {
                uploadedImage = reader.result as Uint8List?;
                print("Image loaded!");
                // Cache the uploaded image
                cacheImage(uploadedImage!);
              });
              try {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await uploadAndCacheImage(user.uid, uploadedImage!);
                } else {
                  setState(() {
                    errorMessage = "User not logged in";
                  });
                }
              } catch (error) {
                setState(() {
                  errorMessage = "Failed to upload image";
                });
              }
            });

            reader.onError.listen((fileEvent) {
              setState(() {
                errorMessage = "Error reading file";
              });
            });

            reader.readAsArrayBuffer(file as html.Blob);
          }
        });
      } else {
        final result =
            await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null) {
          final filePath = result.files.single.path!;
          final imageBytes = await File(filePath).readAsBytes();
          setState(() {
            uploadedImage = Uint8List.fromList(imageBytes);
          });
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await uploadAndCacheImage(user.uid, uploadedImage!);
          } else {
            setState(() {
              errorMessage = "User not logged in";
            });
          }
        }
      }
    } catch (error) {
      setState(() {
        errorMessage = "Failed to pick or upload image";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurpleAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 400,
            width: 500,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Choose a profile picture!',
                      style: TextStyle(fontSize: 24),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent)),
                      child: CircleAvatar(
                        radius: 80.0,
                        backgroundImage: imageUrl != null
                            ? MemoryImage(uploadedImage!)
                            : null,
                        child: uploadedImage == null
                            ? const Icon(
                                Icons.image,
                                size: 60.0,
                              )
                            : null,
                      ),
                      onPressed: () async {
                        pickAndUploadImage();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: widget.onNextPressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
