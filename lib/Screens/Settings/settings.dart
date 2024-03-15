import 'package:cloud_firestore/cloud_firestore.dart';

class Settings {
  String country;
  String doesSmoke;
  String gender;
  String does420;
  List<String> profilePictures;
  String isLookingFor;
  String genderToShow;
  String userId;
  String desiredGenderFriendship;
  String desiredGenderRomance;
  String aboutMe;
  String willRelocate;
  String isSterilized;

  Timestamp DOB;
  String willDoLongDistance;
  String name;
  String doesDrink;
  String dreamPartner;
  int age; // Age property to store the calculated age

  Settings({
    this.country = '',
    this.doesSmoke = '',
    this.gender = '',
    this.does420 = '',
    required this.profilePictures,
    this.isLookingFor = '',
    this.genderToShow = '',
    this.userId = '',
    this.desiredGenderFriendship = '',
    this.desiredGenderRomance = '',
    this.aboutMe = '',
    this.willRelocate = '',
    this.isSterilized = '',
    required this.DOB,
    this.willDoLongDistance = '',
    this.name = '',
    this.doesDrink = '',
    this.dreamPartner = '',
    this.age = 0,
  }) {
    // Calculate age from DOB
    age = _calculateAge();
  }

  factory Settings.fromMap(Map<String, dynamic> data) {
    return Settings(
      country: data['country'] ?? '',
      doesSmoke: data['doesSmoke'] ?? '',
      gender: data['gender'] ?? '',
      does420: data['does420'] ?? '',
      profilePictures: List<String>.from(data['profilePictures'] ?? []),
      isLookingFor: data['isLookingFor'] ?? '',
      genderToShow: data['genderToShow'] ?? '',
      userId: data['userId'] ?? '',
      desiredGenderFriendship: data['desiredGenderFriendship'] ?? '',
      desiredGenderRomance: data['desiredGenderRomance'] ?? '',
      aboutMe: data['aboutMe'] ?? '',
      willRelocate: data['willRelocate'] ?? '',
      isSterilized: data['isSterilized'] ?? '',
      DOB: data['DOB'] ?? Timestamp.now(),
      willDoLongDistance: data['willDoLongDistance'] ?? '',
      name: data['name'] ?? '',
      doesDrink: data['doesDrink'] ?? '',
      dreamPartner: data['dreamPartner'] ?? '',
    );
  }

  int compareSettings(Settings other) {
    int identicalPairs = 0;
    if (this.country == other.country) identicalPairs++;
    if (this.doesSmoke == other.doesSmoke) identicalPairs++;
    if (this.gender == other.gender) identicalPairs++;
    if (this.does420 == other.does420) identicalPairs++;
    // Repeat for other properties...
    return identicalPairs;
  }

  int _calculateAge() {
    final now = DateTime.now();
    final dob = DOB.toDate();
    final age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      return age - 1;
    }
    return age;
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'doesSmoke': doesSmoke,
      'gender': gender,
      'does420': does420,
      'profilePictures': profilePictures,
      'isLookingFor': isLookingFor,
      'genderToShow': genderToShow,
      'userId': userId,
      'desiredGenderFriendship': desiredGenderFriendship,
      'desiredGenderRomance': desiredGenderRomance,
      'aboutMe': aboutMe,
      'willRelocate': willRelocate,
      'isSterilized': isSterilized,
      'DOB': DOB,
      'willDoLongDistance': willDoLongDistance,
      'name': name,
      'doesDrink': doesDrink,
      'dreamPartner': dreamPartner,
      'age': age,
    };
  }
}
