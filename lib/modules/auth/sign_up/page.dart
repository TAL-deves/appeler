import 'package:flutter/material.dart';

import '../../../index.dart';

class SignUpPage extends StatefulWidget {
  static const String route = "sign_up";
  static const String title = "Sign Up";

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final loginManager = di<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthSignUpFragment(
        onSignIn: signIn,
        onSignUp: signUp,
      ),
    );
  }

  void signIn() => Navigator.pop(context);

  Future<bool> signUp(String email, Number number, String password) {
    return loginManager.register(
      email: email,
      phoneNumber: number.numberWithCode,
      password: password,
    );
  }
}
