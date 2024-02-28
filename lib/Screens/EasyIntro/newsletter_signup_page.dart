import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Notifiers/user_notifier.dart';

class NewsletterPage extends StatefulWidget {
  final void Function() onNewsletterButtonPressed;
  const NewsletterPage({
    Key? key,
    required this.onNewsletterButtonPressed,
  }) : super(key: key);

  @override
  _NewsletterPageState createState() => _NewsletterPageState();
}

class _NewsletterPageState extends State<NewsletterPage> {
  UserDataProvider? _userDataNotifier;

  @override
  void initState() {
    super.initState();
    // Initialize the signedUpForNewsletter variable when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    _userDataNotifier ??= Provider.of<UserDataProvider>(context, listen: false);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Subscribe to our newsletter for updates & early access?',
                      style: TextStyle(fontSize: 24),
                    ),
                    Image.asset('assets/newspaper.png',
                        height: 200, width: 200),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Provider.of<UserDataProvider>(context,
                                    listen: false)
                                .signedUpForNewsletter = true;
                            setState(() {
                              _userDataNotifier!.signedUpForNewsletter = true;
                            });
                            _subscribeToNewsletter(
                                context,
                                Provider.of<UserDataProvider>(context,
                                    listen: false));
                            widget.onNewsletterButtonPressed();
                          },
                          // Apply green color if signed up, no styling otherwise
                          style: _userDataNotifier!.signedUpForNewsletter !=
                                  null
                              ? ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    _userDataNotifier!.signedUpForNewsletter!
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                )
                              : ButtonStyle(),
                          child: Text('Yes'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Update signedUpForNewsletter to false
                            Provider.of<UserDataProvider>(context,
                                    listen: false)
                                .signedUpForNewsletter = false;
                            setState(() {
                              _userDataNotifier!.signedUpForNewsletter = false;
                            });
                            widget.onNewsletterButtonPressed();
                          },
                          // Apply green color if not signed up, no styling otherwise
                          style: _userDataNotifier!.signedUpForNewsletter !=
                                  null
                              ? ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    !_userDataNotifier!.signedUpForNewsletter!
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                )
                              : ButtonStyle(),
                          child: Text('Maybe Later'),
                        ),
                      ],
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

  Future<void> _subscribeToNewsletter(
      BuildContext context, UserDataProvider userDataNotifier) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Reference to Firestore collection
        CollectionReference newsletterSignups =
            FirebaseFirestore.instance.collection('newsletter_signups');

        // Check if the user already exists in the collection
        DocumentSnapshot userDoc = await newsletterSignups.doc(userId).get();
        if (!userDoc.exists) {
          // Add the user to the collection if they don't exist
          await newsletterSignups.doc(userId).set({
            'user_id': userId,
            'timestamp': FieldValue.serverTimestamp(),
          });
          // Update signedUpForNewsletter to true
          userDataNotifier.signedUpForNewsletter = true;
          setState(() {
            _userDataNotifier!.signedUpForNewsletter = true;
          });
          // Show a confirmation snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Subscribed to newsletter!')),
          );
        } else {
          // Show a message that the user is already subscribed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are already subscribed!')),
          );
        }
      } else {
        // Handle if user is not authenticated
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You need to sign in first!')),
        );
      }
    } catch (error) {
      print('Error: $error');
      // Handle error
    }
  }
}
