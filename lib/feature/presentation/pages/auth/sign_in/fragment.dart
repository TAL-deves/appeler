import 'package:appeler/feature/presentation/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import '../../../../../index.dart';

class AuthSignInFragment extends StatelessWidget {
  final AuthSignInHandler onSignIn;
  final AuthSignInHandler onSignInWithGoogle;
  final AuthSignInHandler onSignInWithFacebook;
  final AuthForgotHandler onForgetPassword;
  final AuthCreateHandler onCreateAccount;

  const AuthSignInFragment({
    Key? key,
    required this.onSignIn,
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
        onSignInWithGoogle: onSignInWithGoogle,
        onSignInWithFacebook: onSignInWithFacebook,
        onCreateAccount: onCreateAccount,
        onForgetPassword: onForgetPassword,
      ),
      desktop: AuthSignInDesktopBody(
        onSignIn: onSignIn,
        onSignInWithGoogle: onSignInWithGoogle,
        onSignInWithFacebook: onSignInWithFacebook,
        onCreateAccount: onCreateAccount,
        onForgetPassword: onForgetPassword,
      ),
    );
  }
}
