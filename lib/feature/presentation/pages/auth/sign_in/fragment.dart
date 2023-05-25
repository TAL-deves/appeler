import 'package:appeler/feature/presentation/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';

import '../../../../../index.dart';

class AuthSignInFragment extends StatefulWidget {
  final AuthSignInHandler onSignIn;
  final AuthForgotHandler onForgetPassword;
  final AuthCreateHandler onCreateAccount;

  const AuthSignInFragment({
    Key? key,
    required this.onSignIn,
    required this.onForgetPassword,
    required this.onCreateAccount,
  }) : super(key: key);

  @override
  State<AuthSignInFragment> createState() => _AuthSignInFragmentState();
}

class _AuthSignInFragmentState extends State<AuthSignInFragment> {
  late EmailEditingController email;
  late PasswordEditingController password;

  @override
  void initState() {
    email = EmailEditingController();
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
      paddingTop: 120,
      paddingHorizontal: 32,
      paddingBottom: 24,
      children: [
        const AppLogo(),
        const SizedBox(height: 24),
        EmailField(
          controller: email,
          hint: "Enter your email",
        ),
        PasswordField(
          hint: "Enter your password",
          controller: password,
          margin: EdgeInsets.zero,
        ),
        AppTextButton(
          width: double.infinity,
          textAlign: TextAlign.end,
          fontWeight: FontWeight.bold,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
          text: "Forget password?",
          onPressed: () => widget.onForgetPassword.call(AuthInfo(
            email: email.text,
            password: password.text,
          )),
        ),
        Button(
          margin: const EdgeInsets.symmetric(vertical: 24),
          text: "Login",
          borderRadius: 25,
          primary: AppColors.primary,
          onExecute: () => widget.onSignIn.call(AuthInfo(
            email: email.text,
            password: password.text,
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
        CreateAccountTextView(
          width: double.infinity,
          textAlign: TextAlign.center,
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.all(24),
          text: "Don't have an account ?  ",
          textWeight: FontWeight.w500,
          textColor: AppColors.primary.withAlpha(200),
          buttonText: "Sign Up",
          buttonTextColor: AppColors.secondary,
          onPressed: () => widget.onCreateAccount.call(AuthInfo(
            email: email.text,
            password: password.text,
          )),
        ),
      ],
    );
  }
}

