
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class MailService {
  Future<bool> sendMail(String toEmail, String subject, String text) async {
    try {
      final newDocRef =
      FirebaseFirestore.instance.collection('mail').doc(Uuid().v4());

      await newDocRef.set({
        "to": [toEmail],
        'message': {'subject': subject, 'text': text}
      });

      // Wait for the document to be created
      final snapshot = await newDocRef.get();

      // Check if the 'error' property is null
      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!['error'] == null) {
        return true; // Document created successfully without errors
      } else {
        return false; // Document creation had an error
      }
    } catch (e) {
      print('Error sending mail: $e');
      // Handle the error as needed
      return false; // Return false in case of an error
    }
  }
}
