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

  Future<bool> signInWithApple(AuthInfo entity) async {
    return true;
  }

  Future<bool> signInWithGoogle(AuthInfo data) async {
    super.signInByGoogle(data);
    return true;
  }

  Future<bool> signInWithFacebook(AuthInfo data) async {
    super.signInByFacebook(data);
    return true;
  }

  Future<bool> signUp(AuthInfo data) async {
    super.signUpByEmail(data);
    return true;
  }

  Future<bool> forgot(AuthInfo data) async {
    return true;
  }

// Future<Response<Credential>> signInByApple() async {
//   final response = Response<Credential>();
//   try {
//     final credential = await SignInWithApple.getAppleIDCredential(
//       scopes: [
//         AppleIDAuthorizationScopes.email,
//         AppleIDAuthorizationScopes.fullName,
//       ],
//       webAuthenticationOptions: WebAuthenticationOptions(
//         clientId: 'your-apple-sign-in-client-id',
//         redirectUri: Uri.parse(
//           'https://your-redirect-uri.com/redirect',
//         ),
//       ),
//     );
//
//     final oauthCredential = OAuthProvider("apple.com").credential(
//       idToken: credential.identityToken,
//       accessToken: credential.authorizationCode,
//     );
//
//     return response.withData(Credential(
//       credential: oauthCredential,
//     ));
//   } on SignInWithAppleAuthorizationException catch (_) {
//     return response.withException(_.message, status: Status.failure);
//   }
// }
}
