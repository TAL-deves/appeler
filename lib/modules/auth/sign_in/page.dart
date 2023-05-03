import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../index.dart';

class SignInPage extends StatefulWidget {
  static const String route = "sign_in";
  static const String title = "Sign In";

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final loginManager = di<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SignInBody(
        onSignIn: signIn,
        onForgetPassword: forgotPassword,
        onCreateAccount: createAccount,
      ),
    );
  }

  Future<bool> signIn(Number number, String password) {
    return loginManager.login(
      phoneNumber: number.numberWithCode,
      password: password,
    );
  }

  void forgotPassword(Number number, String password) {
    loginManager.forgotPassword(
      phoneNumber: number.numberWithCode,
      password: password,
    );
  }

  void createAccount() {
    Navigator.pushNamed(context, SignUpPage.route);
  }
}
