import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;

class ReverseGeocodeService {
  double lat = 0.0;
  double long = 0.0;
  String city = '';
  String state = '';
  String country = '';
  String countryCode = '';
  String? uid;
  // Constructor that takes uid
  ReverseGeocodeService(String uid) {
    this.uid = uid;
  }

  getLocationAndSetFirestore() async {
    // Grab coordinates using Location
    await getCoordinates();
    if (kIsWeb) {
      // Reverse Geocode using CFC API
      ReverseGeocodeResponse response = await fetchReverseGeocode(lat, long);

      // Assign coordinates to locale
      assignCoordinatesToLocaleFromResponse(response);
    } else {
      // Reverse Geocode using mobile geocoding library
      await getLocaleMobile();
    }
    await updateLocaleInFirestore(uid!);
  }

  Future<void> getUidFromFirebaseAuth() async {
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> updateLocaleInFirestore(String uid) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the user document in Firestore
      DocumentReference userRef = firestore.collection('users').doc(uid);

      // Update the locale property in the user document
      await userRef.set({
        'locale': {
          'city': city,
          'state': state,
          'country': country,
          'countryCode': countryCode,
        },
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating locale in Firestore: $e');
      throw e; // Rethrow the error to handle it in the calling code
    }
  }

  assignCoordinatesToLocaleFromResponse(ReverseGeocodeResponse response) {
    city = response.city!;
    state = response.state!;
    country = response.country!;
    countryCode = response.countryCode!;
  }

  Future<ReverseGeocodeResponse> fetchReverseGeocode(
      double latitude, double longitude) async {
    final url = Uri.parse('https://aianyone.net/cfc/reverse_geocode');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'lat': latitude, 'long': longitude}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ReverseGeocodeResponse(
        city: data['city'] ?? 'N\\A',
        state: data['state'] ?? 'N\\A',
        country: data['country'] ?? 'N\\A',
        countryCode: data['country_code'] ?? 'N\\A',
      );
    } else {
      return ReverseGeocodeResponse(
        city: 'N\\A',
        state: 'N\\A',
        country: 'N\\A',
        countryCode: 'N\\A',
      );
    }
  }

  Future<void> getCoordinates() async {
    loc.LocationData? locationData;
    loc.Location location = loc.Location();

    try {
      locationData = await location.getLocation();
      lat = locationData.latitude!;

      long = locationData.longitude!;
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> getLocaleMobile() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    if (placemarks != null && placemarks.isNotEmpty) {
      city = placemarks[0].locality ?? 'N\\A';
      state = placemarks[0].administrativeArea ?? 'N\\A';
      country = placemarks[0].country ?? 'N\\A';
      countryCode = placemarks[0].isoCountryCode ?? 'N\\A';
    } else {
      setLocaleToNotAvailable();
    }
  }

  void setLocaleToNotAvailable() {
    city = 'N\\A';
    state = 'N\\A';
    country = 'N\\A';
    countryCode = 'N\\A';
  }

  Future<void> _getLocationMobile() async {
    loc.LocationData? locationData;
    loc.Location location = loc.Location();

    try {
      locationData = await location.getLocation();
      lat = locationData.latitude!;

      long = locationData.longitude!;
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}

class ReverseGeocodeResponse {
  final String? city;
  final String? state;
  final String? country;
  final String? countryCode;

  ReverseGeocodeResponse({
    required this.city,
    required this.state,
    required this.country,
    required this.countryCode,
  });
}
