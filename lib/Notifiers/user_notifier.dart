import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utils/debug_utils.dart';

class UserDataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Map<String, dynamic>? _userData;

  UserDataProvider() {
    _init();
  }

  Future<void> _init() async {
    await _getUserData();
    if (_user != null) {
      _subscribeToUserDataChanges();
      DebugUtils.printDebug('Subscribed to user snapshot');
    }
  }

  Future<void> _getUserData() async {
    DebugUtils.printDebug('Getting user data...');
    try {
      _user = _auth.currentUser;
      if (_user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('users').doc(_user!.uid).get();
        _userData = snapshot.data();
        DebugUtils.printDebug('Got the user!');
      }
    } catch (error) {
      print('Error loading user data: $error');
    }
  }

  void _subscribeToUserDataChanges() {
    _firestore
        .collection('users')
        .doc(_user!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _userData = snapshot.data();
        notifyListeners();
      }
    });
  }

  dynamic getProperty(String property) {
    DebugUtils.printDebug('Getting property: $property');
    if (_userData != null && _userData!.containsKey(property)) {
      DebugUtils.printDebug('Found property: $property');
      return _userData![property];
    }
    return null;
  }

  Future<void> setProperty(String property, dynamic value) async {
    try {
      // Update locally
      _userData?[property] = value;
      notifyListeners();

      // Update in Firestore
      await _firestore.collection('users').doc(_user!.uid).update({
        property: value,
      });
    } catch (error) {
      print('Error setting property $property: $error');
    }
  }
}
