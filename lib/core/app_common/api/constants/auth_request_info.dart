import 'dart:convert';

import '../../../../index.dart';

class AuthRequestInfo {
  final String? _accessToken;
  final String? _authorization;
  final String? _email;
  final String? _grantType;
  final String? _phoneNumber;
  final String? _password;

  String get accessToken => _accessToken ?? "";

  String get authorization => _authorization ?? "";

  String get email => _email ?? "";

  String get grantType => _grantType ?? "";

  String get phoneNumber => _phoneNumber ?? "";

  String get password => _password ?? "";

  const AuthRequestInfo._({
    String? authorization,
    String? email,
    String? grantType,
    String? accessToken,
    String? phoneNumber,
    String? password,
  })  : _accessToken = accessToken,
        _authorization = authorization,
        _email = email,
        _grantType = grantType,
        _password = password,
        _phoneNumber = phoneNumber;

  factory AuthRequestInfo.refreshToken({
    required String accessToken,
    required String phoneNumber,
    required String password,
  }) {
    return AuthRequestInfo._(
      accessToken: accessToken,
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  factory AuthRequestInfo.signIn({
    String authorization = ApiInfo.authorization,
    String grantType = ApiInfo.grantType,
    required String phoneNumber,
    required String password,
  }) {
    return AuthRequestInfo._(
      authorization: authorization,
      grantType: grantType,
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  factory AuthRequestInfo.signOut({
    String authorization = ApiInfo.authorization,
    String grantType = ApiInfo.grantType,
    required String phoneNumber,
    required String password,
  }) {
    return AuthRequestInfo._(
      authorization: authorization,
      grantType: grantType,
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  factory AuthRequestInfo.signUp({
    required String email,
    required String phoneNumber,
    required String password,
  }) {
    return AuthRequestInfo._(
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  String request() => jsonEncode(source);

  Map<String, dynamic> get source {
    return {
      if (accessToken.isNotEmpty) 'accessToken': _accessToken,
      if (authorization.isNotEmpty) 'authorization': _authorization,
      if (email.isNotEmpty) 'email': _email,
      if (grantType.isNotEmpty) 'grant_type': _grantType,
      if (phoneNumber.isNotEmpty) 'phoneNumber': _phoneNumber,
      if (password.isNotEmpty) 'password': _password,
    };
  }
}
