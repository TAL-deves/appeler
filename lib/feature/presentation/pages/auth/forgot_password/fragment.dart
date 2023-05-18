import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';

import '../../../../../index.dart';

class AuthForgotPasswordFragment extends StatefulWidget {
  final AuthForgotHandler onForgot;

  const AuthForgotPasswordFragment({
    Key? key,
    required this.onForgot,
  }) : super(key: key);

  @override
  State<AuthForgotPasswordFragment> createState() =>
      _AuthForgotPasswordFragmentState();
}

class _AuthForgotPasswordFragmentState
    extends State<AuthForgotPasswordFragment> {
  late EmailEditingController email;
  late PhoneEditingController phone;

  @override
  void initState() {
    email = EmailEditingController();
    phone = PhoneEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LinearLayout(
        orientation: Axis.vertical,
        paddingVertical: 24,
        paddingHorizontal: 32,
        children: [
          const TextView(
            width: double.infinity,
            text: "Forgot password",
            textAlign: TextAlign.start,
            textColor: Colors.black,
            fontWeight: FontWeight.bold,
            textSize: 24,
            marginVertical: 24,
          ),
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
          Button(
            margin: const EdgeInsets.symmetric(vertical: 24),
            text: "Find",
            borderRadius: 12,
            primary: AppColors.primary,
            onExecute: () => widget.onForgot.call(UserEntity(
              email: email.text,
              phone: phone.number.numberWithCode,
            )),
          ),
        ],
      ),
    );
  }
}
