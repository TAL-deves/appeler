import 'dart:convert';

class ApiInfo {
  const ApiInfo._();

  static const appBaseUrl = 'http://192.168.68.116:5000/';

  static const basicHeaderUser = 'application';
  static const basicHeaderPass = 'secret';
  static const authorization = '$basicHeaderUser:$basicHeaderPass';
  static const grantType = 'password';
  static final basicHeader =
      'Basic ${base64Encode(utf8.encode('$basicHeaderUser:$basicHeaderPass'))}';

  static const String login = "auth/login";
  static const String register = "auth/signup";
  static const String emailNPassword = "";
  static const String logout = "";
  static const String clearToken = "auth/logout";
}