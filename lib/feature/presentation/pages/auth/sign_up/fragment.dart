import 'package:flutter/material.dart';

import '../../../../../index.dart';
import '../../../widgets/responsive_layout.dart';

class AuthSignUpFragment extends StatelessWidget {
  final AuthSignInHandler onSignIn;
  final AuthSignInHandler onSignInWithGoogle;
  final AuthSignInHandler onSignInWithFacebook;
  final AuthSignUpHandler onSignUp;

  const AuthSignUpFragment({
    Key? key,
    required this.onSignIn,
    required this.onSignInWithGoogle,
    required this.onSignInWithFacebook,
    required this.onSignUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: AuthSignUpMobileBody(
        onSignIn: onSignIn,
        onSignInWithGoogle: onSignInWithGoogle,
        onSignInWithFacebook: onSignInWithFacebook,
        onSignUp: onSignUp,
      ),
      desktop: AuthSignUpDesktopBody(
        onSignIn: onSignIn,
        onSignInWithGoogle: onSignInWithGoogle,
        onSignInWithFacebook: onSignInWithFacebook,
        onSignUp: onSignUp,
      ),
    );
  }
}
