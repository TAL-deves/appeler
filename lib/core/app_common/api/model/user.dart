import 'dart:convert' as converter;

class User {
  final String? _username;

  String get username => _username ?? "";

  const User({
    String? username,
  }) : _username = username;

  User copy({
    String? username,
  }) {
    return User(
      username: username ?? _username,
    );
  }

  String get json => converter.jsonEncode(source);

  factory User.from(dynamic data) {
    var source = {};
    if (data is String) {
      source = converter.jsonDecode(data);
    }
    if (data is Map<String, dynamic>) {
      source = data;
    }
    return User(
      username: source["username"],
    );
  }

  Map<String, dynamic> get source {
    return {
      "username": _username,
    };
  }
}
