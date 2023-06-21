import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_andomie/core.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends DefaultAuthController {
  AuthController({
    required super.handler,
    required super.userHandler,
  });

  Future<bool> signIn(AuthInfo data) async {
    await super.signInByEmail(data);
    return true;
  }

  Future<bool> signInWithApple(AuthInfo entity) async {
    var a = await signInByApple();
    var b = a.data;
    handler.signUpWithCredential(credential: b!.credential!);
    return true;
  }

  Future<bool> signInWithGoogle(AuthInfo data) async {
    await super.signInByGoogle(data);
    return true;
  }

  Future<bool> signInWithFacebook(AuthInfo data) async {
    await super.signInByFacebook(data);
    return true;
  }

  Future<bool> signUp(AuthInfo data) async {
    await super.signUpByEmail(data);
    return true;
  }

  Future<bool> forgot(AuthInfo data) async {
    return true;
  }

  Future<Response<Credential>> signInByApple() async {
    final response = Response<Credential>();
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      return response.withData(Credential(
        credential: oauthCredential,
      ));
    } on SignInWithAppleAuthorizationException catch (_) {
      return response.withException(_.message, status: Status.failure);
    }
  }
}
