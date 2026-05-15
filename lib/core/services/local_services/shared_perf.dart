import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../modules/auth/models/user_model.dart';

enum PrefKeys { user, isLoggedIn, onBoardingV2, guestUser }

class SharedPrefController {
  static final _instance = SharedPrefController._();

  factory SharedPrefController() {
    return _instance;
  }

  late SharedPreferences preferences;
  SharedPrefController._();

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<void> save(UserModel user) async {
    String userEncoded = jsonEncode(user.toJsonUser());
    await preferences.setString(PrefKeys.user.toString(), userEncoded);
  }

  UserModel getUser() {
    String userJson = preferences.getString(PrefKeys.user.toString()) ?? '';
    if (userJson.isEmpty) {
      return UserModel(name: '', email: '', phone: '', password: '');
    }
    final userObject = jsonDecode(userJson);
    return UserModel.fromJson(userObject);
  }

  void isLoggedIn({required bool value}) {
    preferences.setBool(PrefKeys.isLoggedIn.toString(), value);
  }

  bool getLoggedIn() {
    return preferences.getBool(PrefKeys.isLoggedIn.toString()) ?? false;
  }

  void setOnBoarding({required bool value}) {
    preferences.setBool(PrefKeys.onBoardingV2.toString(), value);
  }

  void setGuestUser({required bool value}) {
    preferences.setBool(PrefKeys.guestUser.toString(), value);
  }

  bool getGuestUser() {
    return preferences.getBool(PrefKeys.guestUser.toString()) ?? false;
  }

  bool getOnBoarding() {
    return preferences.getBool(PrefKeys.onBoardingV2.toString()) ?? false;
  }

  void clear() {
    preferences.clear();
  }

  void remove() {
    preferences.remove(PrefKeys.user.toString());
  }
}
