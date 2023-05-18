import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefData {
  static Future<bool> isAuthorised() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool("isAuthorised") ?? false;
  }

  static Future<bool> passwordVerificationPassed(String password) async {
    final pref = await SharedPreferences.getInstance();
    var currentPassword = pref.getString("pin") ?? "";

    return currentPassword == password;
  }

  static Future<String> getUser() async {
    final pref = await SharedPreferences.getInstance();
    var user = pref.getString("user") ?? "";
    return user;
  }

  static Future<String> getStorage() async {
    final pref = await SharedPreferences.getInstance();
    var storage = pref.getString("storage") ?? "";
    return storage;
  }
}
