import 'package:flutter_andomie/core.dart';

class AuthController extends DefaultAuthController {

  AuthController({
    required super.handler,
    required super.userHandler,
  });

  Future<bool> signIn(AuthInfo data) async {
    super.signInByEmail(data);
    return true;
  }

  Future<bool> signUp(AuthInfo data) async {
    super.signUpByEmail(data);
    return true;
  }

  Future<bool> forgot(AuthInfo data) async {
    return true;
  }
}
