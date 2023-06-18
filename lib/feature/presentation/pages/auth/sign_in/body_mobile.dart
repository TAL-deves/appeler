import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../index.dart';

class AuthSignInMobileBody extends StatefulWidget {
  final AuthSignInHandler onSignIn;
  final AuthSignInHandler onSignInWithGoogle;
  final AuthSignInHandler onSignInWithFacebook;
  final AuthForgotHandler onForgetPassword;
  final AuthCreateHandler onCreateAccount;

  const AuthSignInMobileBody({
    Key? key,
    required this.onSignIn,
    required this.onSignInWithGoogle,
    required this.onSignInWithFacebook,
    required this.onForgetPassword,
    required this.onCreateAccount,
  }) : super(key: key);

  @override
  State<AuthSignInMobileBody> createState() => _AuthSignInMobileBodyState();
}

class _AuthSignInMobileBodyState extends State<AuthSignInMobileBody> {
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
      widthMax: 420,
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
        // AppTextButton(
        //   width: double.infinity,
        //   textAlign: TextAlign.end,
        //   fontWeight: FontWeight.bold,
        //   padding: const EdgeInsets.symmetric(
        //     vertical: 12,
        //     horizontal: 8,
        //   ),
        //   text: "Forget password?",
        //   onPressed: () => widget.onForgetPassword.call(AuthInfo(
        //     email: email.text,
        //     password: password.text,
        //   )),
        // ),
        BlocBuilder<AuthController, AuthResponse<AuthInfo>>(
          builder: (context, state) {
            return StackLayout(
              width: double.infinity,
              marginVertical: 24,
              height: 65,
              children: [
                if (state.isLoading)
                  const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  )
                else
                  AppButton(
                    text: "Sign In",
                    borderRadius: 25,
                    primary: AppColors.primary,
                    onExecute: () => widget.onSignIn.call(
                      AuthInfo(
                        email: email.text,
                        password: password.text,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const OrText(),
        OAuthButton(
          text: "Login With Google",
          background: AppColors.primary,
          icon: AppIcons.google,
          onClick: (context) => widget.onSignInWithGoogle.call(
            AuthInfo(
              email: email.text,
              password: password.text,
            ),
          ),
        ),
        // OAuthButton(
        //   text: "Login With Facebook",
        //   background: AppColors.secondary,
        //   icon: AppIcons.facebook,
        //   onClick: (context) => widget.onSignInWithFacebook.call(
        //     AuthInfo(
        //       email: email.text,
        //       password: password.text,
        //     ),
        //   ),
        // ),
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
