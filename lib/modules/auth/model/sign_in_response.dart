import 'dart:convert' as converter;

import '../../../../index.dart';

class SignInResponse {
  final bool? _success;
  final bool? _error;
  final dynamic _errorMessage;
  final SignInData? _data;

  bool get isSuccessful => _success ?? false;

  bool get isError => _error ?? false;

  String get errorMessage => _errorMessage ?? "";

  SignInData get data => _data ?? const SignInData();

  SignInResponse({
    bool? success,
    SignInData? data,
    bool? error,
    dynamic errorMessage,
  })  : _errorMessage = errorMessage,
        _data = data,
        _error = error,
        _success = success;

  SignInResponse copy({
    bool? error,
    dynamic errorMessage,
    bool? success,
    SignInData? data,
  }) {
    return SignInResponse(
      success: success ?? _success,
      data: data ?? _data,
      error: error ?? _error,
      errorMessage: errorMessage ?? _errorMessage,
    );
  }

  factory SignInResponse.from(dynamic body) {
    var source = {};
    if (body is String) {
      source = converter.jsonDecode(body);
    }
    if (body is Map<String, dynamic>) {
      source = body;
    }
    final error = source["isError"];
    final success = source["success"];
    final message = source["error"];
    final data = source["data"];

    return SignInResponse(
      error: error is bool ? error : null,
      errorMessage: message is String ? message : null,
      success: success is bool ? success : null,
      data: SignInData.from(data),
    );
  }

  String get json => converter.jsonEncode(source);

  Map<String, dynamic> get source {
    return {
      "success": _success,
      "isError": _error,
      "error": _errorMessage,
      "data": _data?.source,
    };
  }
}

class SignInData {
  final String? _accessToken;
  final String? _refreshToken;
  final DateTime? _accessTokenExpiresAt;
  final DateTime? _refreshTokenExpiresAt;
  final Client? _client;
  final User? _user;

  String get accessToken => _accessToken ?? "";

  String get refreshToken => _refreshToken ?? "";

  DateTime get accessTokenExpiresAt => _accessTokenExpiresAt ?? DateTime.now();

  DateTime get refreshTokenExpiresAt =>
      _refreshTokenExpiresAt ?? DateTime.now();

  Client get client => _client ?? const Client();

  User get user => _user ?? const User();

  const SignInData({
    String? accessToken,
    DateTime? accessTokenExpiresAt,
    String? refreshToken,
    DateTime? refreshTokenExpiresAt,
    Client? client,
    User? user,
  })  : _user = user,
        _client = client,
        _refreshTokenExpiresAt = refreshTokenExpiresAt,
        _refreshToken = refreshToken,
        _accessTokenExpiresAt = accessTokenExpiresAt,
        _accessToken = accessToken;

  SignInData copy({
    String? accessToken,
    DateTime? accessTokenExpiresAt,
    String? refreshToken,
    DateTime? refreshTokenExpiresAt,
    Client? client,
    User? user,
  }) {
    return SignInData(
      accessToken: accessToken ?? _accessToken,
      accessTokenExpiresAt: accessTokenExpiresAt ?? _accessTokenExpiresAt,
      refreshToken: refreshToken ?? _refreshToken,
      refreshTokenExpiresAt: refreshTokenExpiresAt ?? _refreshTokenExpiresAt,
      client: client ?? _client,
      user: user ?? _user,
    );
  }

  String get json => converter.jsonEncode(source);

  factory SignInData.from(dynamic data) {
    var source = {};
    if (data is String) {
      source = converter.jsonDecode(data);
    }
    if (data is Map<String, dynamic>) {
      source = data;
    }
    final accessToken = source["accessToken"];
    final accessTokenExpiresAt = source["accessTokenExpiresAt"];
    final refreshToken = source["refreshToken"];
    final refreshTokenExpiresAt = source["refreshTokenExpiresAt"];
    final client = source["client"];
    final user = source["user"];

    return SignInData(
      accessToken: accessToken is String ? accessToken : null,
      refreshToken: refreshToken is String ? refreshToken : null,
      accessTokenExpiresAt: DateTime.tryParse(accessTokenExpiresAt),
      refreshTokenExpiresAt: DateTime.tryParse(refreshTokenExpiresAt),
      client: Client.from(client),
      user: User.from(user),
    );
  }

  Map<String, dynamic> get source {
    return {
      "accessToken": _accessToken,
      "accessTokenExpiresAt": _accessTokenExpiresAt?.toIso8601String(),
      "refreshToken": _refreshToken,
      "refreshTokenExpiresAt": _refreshTokenExpiresAt?.toIso8601String(),
      "client": _client?.source,
      "user": _user?.source,
    };
  }
}
