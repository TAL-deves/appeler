import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';

import '../../../../../index.dart';

class AuthSignUpFragment extends StatefulWidget {
  final AuthSignInHandler onSignIn;
  final AuthSignUpHandler onSignUp;

  const AuthSignUpFragment({
    Key? key,
    required this.onSignIn,
    required this.onSignUp,
  }) : super(key: key);

  @override
  State<AuthSignUpFragment> createState() => _AuthSignUpFragmentState();
}

class _AuthSignUpFragmentState extends State<AuthSignUpFragment> {
  late EmailEditingController email;
  late PhoneEditingController phone;
  late PasswordEditingController password;

  @override
  void initState() {
    email = EmailEditingController();
    phone = PhoneEditingController();
    password = PasswordEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      scrollable: true,
      orientation: Axis.vertical,
      crossGravity: CrossAxisAlignment.center,
      paddingTop: 80,
      paddingHorizontal: 32,
      paddingBottom: 24,
      children: [
        const AppLogo(),
        const SizedBox(height: 24),
        // const TextView(
        //   width: double.infinity,
        //   text: "Create a new account",
        //   textAlign: TextAlign.start,
        //   textColor: Colors.black,
        //   fontWeight: FontWeight.bold,
        //   textSize: 24,
        //   marginVertical: 24,
        // ),
        EmailField(
          hint: "Enter your email",
          controller: email,
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
        CreateAccountTextView(
          width: double.infinity,
          textAlign: TextAlign.end,
          padding: const EdgeInsets.all(12),
          text: "Already have an account?  ",
          buttonText: "Login here",
          textColor: AppColors.primary,
          textWeight: FontWeight.w500,
          onPressed: () => widget.onSignIn(AuthInfo(
            email: email.text,
            password: password.text,
            phone: phone.number.numberWithCode,
          )),
        ),
        Button(
          margin: const EdgeInsets.symmetric(vertical: 24),
          text: "Sign up",
          borderRadius: 25,
          primary: AppColors.primary,
          onExecute: () => widget.onSignUp.call(AuthInfo(
            email: email.text,
            password: password.text,
            phone: phone.number.numberWithCode,
          )),
        ),
        const OrText(),
        OAuthButton(
          text: "Login With Google",
          background: AppColors.primary,
          icon: "logo",
          onClick: (context) {},
        ),
        OAuthButton(
          text: "Login With Facebook",
          background: AppColors.secondary,
          icon: "logo",
          onClick: (context) {},
        ),
      ],
    );
  }
}
