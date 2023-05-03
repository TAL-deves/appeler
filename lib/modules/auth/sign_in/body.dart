import 'package:flutter/material.dart';

import '../../../index.dart';

typedef OnSignIn = Future<bool> Function(
  Number number,
  String password,
);
typedef OnForgotPassword = void Function(
  Number number,
  String password,
);
typedef OnCreateAccount = void Function();

class SignInBody extends StatefulWidget {
  final OnSignIn onSignIn;
  final OnForgotPassword onForgetPassword;
  final OnCreateAccount onCreateAccount;

  const SignInBody({
    Key? key,
    required this.onSignIn,
    required this.onForgetPassword,
    required this.onCreateAccount,
  }) : super(key: key);

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  late PhoneEditingController phone;
  late PasswordEditingController password;

  @override
  void initState() {
    phone = PhoneEditingController();
    password = PasswordEditingController();
    super.initState();
  }

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextView(
              width: double.infinity,
              text: "Sign in",
              textAlign: TextAlign.start,
              textColor: Colors.black,
              textStyle: FontWeight.bold,
              textSize: 24,
              margin: EdgeInsets.symmetric(vertical: 24),
            ),
            PhoneField(
              controller: phone,
              textCode: "+880",
              hintCode: "+880",
              hintNumber: "Enter phone number",
            ),
            PasswordField(
              hint: "Enter your password",
              controller: password,
              margin: EdgeInsets.zero,
            ),
            AppTextButton(
              width: double.infinity,
              textAlign: TextAlign.end,
              padding: const EdgeInsets.all(8),
              text: "Forget password?",
              onPressed: () {
                widget.onForgetPassword.call(phone.number, password.text);
              },
            ),
            AppNewAccountTextButton(
              width: double.infinity,
              textAlign: TextAlign.end,
              padding: const EdgeInsets.all(8),
              text: "Don't have an account? ",
              buttonText: "Sign up!",
              buttonTextColor: KColors.primary,
              onPressed: widget.onCreateAccount,
            ),
            Button(
              margin: const EdgeInsets.symmetric(vertical: 24),
              text: "Login",
              borderRadius: 12,
              primary: KColors.primary,
              onExecute: () =>
                  widget.onSignIn.call(phone.number, password.text),
            ),
          ],
        ),
      ),
    );
  }
}
