// Responsible for uploading images to Firebase Storage
// Relays those image URLs to the notifier
// Notifier is then used to display the images in the profile

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;

import '../Notifiers/all_users_notifier.dart';

class ImagePickerService {
  AllUsersNotifier _allUsersNotifier;

  ImagePickerService(this._allUsersNotifier);

  Map<String, String> _imageUrls = {};
  Map<String, Uint8List> _imageBytes = {};

  Map<String, String> get imageUrls => _imageUrls;
  Map<String, Uint8List> get imageBytes => _imageBytes;

  Future<void> pickAndUploadImage(int? index) async {
    index = index ?? -1;
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
              final uploadedImage = reader.result as Uint8List?;
              print("Image loaded!");
              // Cache the uploaded image
              if (uploadedImage != null) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await uploadImage(user.uid, uploadedImage, index!);
                } else {
                  // Handle user not logged in
                }
              }
            });

            reader.onError.listen((fileEvent) {
              // Handle error reading file
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
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await uploadImage(user.uid, Uint8List.fromList(imageBytes), index);
          } else {
            // Handle user not logged in
          }
        }
      }
    } catch (error) {
      // Handle error
    }
  }

  // Uploads image to Firebase Storage
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

  // Uploads image to the notifier
  Future<void> uploadImage(
      String userId, Uint8List imageBytes, int index) async {
    // Implement your image upload logic here
    // After uploading, you can cache the image URL and bytes
    final imageUrl = await _uploadImageToStorage(userId, imageBytes);
    if (index == -1)
      _allUsersNotifier.addProfilePicture(userId, imageUrl);
    else {
      _allUsersNotifier.uploadProfilePictureAtIndex(index, imageUrl);
    }
  }
}
