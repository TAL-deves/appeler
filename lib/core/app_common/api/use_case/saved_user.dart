import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../index.dart';

abstract class SavedUserUseCase {
  Future<bool> save(SignInResponse response);

  SignInResponse? get curUser;

  Future<bool> removeUser();

  static var userId = '';
  static var phoneNumber = '';
  static var fullName = '';
  static var email = '';
  static var isDeveloper = false;
  static var isInstructor = false;
}

class SavedUserUseCaseImp implements SavedUserUseCase {
  final SharedPreferences sharedPreferences;
  final _userKey = 'user';

  SavedUserUseCaseImp({required this.sharedPreferences});

  void _setUserValue(String value) {
    SavedUserUseCase.userId = value;
  }

  @override
  Future<bool> save(SignInResponse response) {
    _setUserValue(response.data.user.username);
    return sharedPreferences.setString(_userKey, response.json);
  }

  @override
  SignInResponse? get curUser {
    final userString = sharedPreferences.getString(_userKey);
    if (userString == null) {
      return null;
    } else {
      final response = SignInResponse.from(jsonDecode(userString));
      _setUserValue(response.data.user.username);
      return response;
    }
  }

  @override
  Future<bool> removeUser() {
    _setUserValue('');
    return sharedPreferences.remove(_userKey);
  }
}
