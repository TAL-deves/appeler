import 'package:flutter_andomie/core.dart';

class AppAuthController extends DefaultAuthController {

  AppAuthController({
    required super.handler,
    required super.userHandler,
    required super.createUid,
  });

  Future<bool> signIn(AuthInfo data) async {
    await signInByEmail(data);
    return true;
  }

  Future<bool> signUp(AuthInfo data) async {
    await signUpByEmail(data);
    return true;
  }

  Future<bool> forgot(AuthInfo data) async {
    return true;
  }
}
