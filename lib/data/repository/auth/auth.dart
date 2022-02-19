import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.sharedPreferences});

  String getUserToken() {
    return sharedPreferences.getString("token")!;
  }

  String getUserIdentityNumber() {
    Map<String, dynamic> prefs = json.decode(sharedPreferences.getString("user")!);
    return prefs["identityNumber"];
  }

  String getUserFullName() {
    Map<String, dynamic> prefs = json.decode(sharedPreferences.getString("user")!);
    return prefs["fullname"] ?? "-";
  }

  String getUserEmailAddress() {
    Map<String, dynamic> prefs = json.decode(sharedPreferences.getString("user")!);
    return prefs["email"];
  }

  String getUserDateOfBirth() {
    Map<String, dynamic> prefs = json.decode(sharedPreferences.getString("user")!);
    return prefs["dateOfBirth"];
  }

  String getUserGender() {
    Map<String, dynamic> prefs = json.decode(sharedPreferences.getString("user")!);
    return prefs["gender"];
  }

  String getUserNik() {
    Map<String, dynamic> prefs = json.decode(sharedPreferences.getString("user")!);
    return prefs["nik"];
  }

  String getUserPhone() {
    Map<String, dynamic> prefs = json.decode(sharedPreferences.getString("user")!);
    return prefs["phone"];
  }

  String getUserPlaceOfBirth() {
    Map<String, dynamic> prefs = json.decode(sharedPreferences.getString("user")!);
    return prefs["placeOfBirth"];
  }

  String? getUserId() {
    Map<String, dynamic> prefs = json.decode(sharedPreferences.getString("user")!);
    return prefs["userId"];
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey("token");
  }
}