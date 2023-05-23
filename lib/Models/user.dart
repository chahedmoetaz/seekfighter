import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';


class User {
  String userID;
  String email;
  String firstName;
  String lastName;

  int height;
  int age;
  int weight;
  String gender;
  String searchfor;
  double lon;
  double lat;

  Timestamp lastOnlineTimestamp;


  String profilePictureURL;
  List<String>matches;
  List<String>notmatches;

  String appIdentifier;

  User(
      { this.userID = '',this.email = '',
      this.firstName = '',
        this.lastName = '',
      this.height ,
      this.age ,
      this.weight ,
      this.gender,
      this.searchfor,
        this.matches,
        this.notmatches,
      lastOnlineTimestamp,
      this.lon,
        this.lat,
      this.profilePictureURL})
      : this.lastOnlineTimestamp = lastOnlineTimestamp ?? Timestamp.now(),
        this.appIdentifier = 'Flutter Login Screen ${Platform.operatingSystem}';

  String fullName() {
    return '$firstName $lastName';
  }

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        userID: parsedJson['uid'] ?? parsedJson['uid'] ?? '',
        email: parsedJson['email'] ?? '',
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        height: parsedJson['height'] ?? null,
        age: parsedJson['age'],
        weight: parsedJson['weight'],
        gender: parsedJson['gender'] ?? '',
        searchfor: parsedJson['searchfor'] ?? '',
        lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],

        profilePictureURL: parsedJson['photo'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': this.userID,
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'height': this.height,
      'age': this.age,
      'weight': this.weight,
      'gender': this.gender,
      'searchfor': this.searchfor,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'photo': this.profilePictureURL,
      'appIdentifier': this.appIdentifier
    };
  }
}