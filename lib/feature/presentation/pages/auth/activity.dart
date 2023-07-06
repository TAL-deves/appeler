import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class AuthActivity extends StatelessWidget {
  static const String route = "/auth";
  static const String title = "Auth";
  final AuthFragmentType? type;
  final bool? isFromWelcome;

  const AuthActivity({
    Key? key,
    required this.isFromWelcome,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      body: BlocConsumer<AuthController, AuthResponse<AuthInfo>>(
        listener: (context, state) {
          if (state.isError || state.isMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.isMessage ? state.message : state.error),
              ),
            );
          }
          if (state.isAuthenticated) {
            AppNavigator.of(context).goHome(
              HomeActivity.route,
              extra: state.data,
            );
          }
        },
        builder: (context, state) {
          return AuthFragment(
            isFromWelcome: isFromWelcome ?? false,
            type: type ?? AuthFragmentType.signIn,
          );
        },
      ),
    );
  }
}

enum AuthFragmentType {
  signIn,
  signUp,
  forgotPassword,
}
