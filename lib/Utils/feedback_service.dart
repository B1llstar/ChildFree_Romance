import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackService {
  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');

  Future<void> submitFeedback(String feedback) async {
    try {
      await _feedbackCollection.add({'feedback': feedback});
      print('Feedback submitted successfully!');
    } catch (e) {
      print('Error submitting feedback: $e');
    }
  }
}
