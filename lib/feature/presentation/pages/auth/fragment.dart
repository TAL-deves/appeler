import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../index.dart';

typedef AuthCreateHandler = Function(AuthInfo data);
typedef AuthForgotHandler = Function(AuthInfo data);

typedef AuthSignInHandler = Function(AuthInfo data);
typedef AuthSignUpHandler = Function(AuthInfo data);

class AuthFragment extends StatefulWidget {
  final bool isFromWelcome;
  final AuthFragmentType type;

  const AuthFragment({
    Key? key,
    required this.isFromWelcome,
    required this.type,
  }) : super(key: key);

  @override
  State<AuthFragment> createState() => _AuthFragmentState();
}

class _AuthFragmentState extends State<AuthFragment> {
  late AuthController controller;

  @override
  void initState() {
    controller = context.read<AuthController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case AuthFragmentType.signIn:
        return AuthSignInFragment(
          onSignIn: controller.signIn,
          onSignInWithGoogle: controller.signInWithGoogle,
          onSignInWithFacebook: controller.signInWithFacebook,
          onCreateAccount: (data) => context.push(
            AuthActivity.route,
            extra: {"type": AuthFragmentType.signUp},
          ),
          onForgetPassword: (data) => context.push(
            AuthActivity.route,
            extra: {"type": AuthFragmentType.forgotPassword},
          ),
        );
      case AuthFragmentType.signUp:
        return AuthSignUpFragment(
          onSignUp: controller.signUp,
          onSignInWithGoogle: controller.signInWithGoogle,
          onSignInWithFacebook: controller.signInWithFacebook,
          onSignIn: (data) {
            if (widget.isFromWelcome) {
              context.push(AuthActivity.route);
            } else {
              Navigator.pop(context);
            }
          },
        );
      case AuthFragmentType.forgotPassword:
        return AuthForgotPasswordFragment(
          onForgot: controller.forgot,
        );
    }
  }
}
