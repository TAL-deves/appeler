import 'package:appeler/feature/presentation/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import '../../../../../index.dart';

class AuthSignInFragment extends StatelessWidget {
  static String route = "sign_in";
  final AuthSignInHandler onSignIn;
  final AuthSignInHandler onSignInWithApple;
  final AuthSignInHandler onSignInWithBiometric;
  final AuthSignInHandler onSignInWithGoogle;
  final AuthSignInHandler onSignInWithFacebook;
  final AuthForgotHandler onForgetPassword;
  final AuthCreateHandler onCreateAccount;

  const AuthSignInFragment({
    Key? key,
    required this.onSignIn,
    required this.onSignInWithApple,
    required this.onSignInWithBiometric,
    required this.onSignInWithGoogle,
    required this.onSignInWithFacebook,
    required this.onForgetPassword,
    required this.onCreateAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: AuthSignInMobileBody(
        onSignIn: onSignIn,
        onSignInWithApple: onSignInWithApple,
        onSignInWithBiometric: onSignInWithBiometric,
        onSignInWithGoogle: onSignInWithGoogle,
        onSignInWithFacebook: onSignInWithFacebook,
        onCreateAccount: onCreateAccount,
        onForgetPassword: onForgetPassword,
      ),
      desktop: AuthSignInDesktopBody(
        onSignIn: onSignIn,
        onSignInWithApple: onSignInWithApple,
        onSignInWithGoogle: onSignInWithGoogle,
        onSignInWithFacebook: onSignInWithFacebook,
        onCreateAccount: onCreateAccount,
        onForgetPassword: onForgetPassword,
      ),
    );
  }
}
