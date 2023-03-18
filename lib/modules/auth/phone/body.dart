import 'package:flutter/material.dart';

import '../../../widgets/button.dart';
import '../../../widgets/password_field.dart';
import '../../../widgets/phone_field.dart';
import '../../../widgets/text_view.dart';
import '../otp/page.dart';

class AuthPhoneBody extends StatefulWidget {
  const AuthPhoneBody({Key? key}) : super(key: key);

  @override
  State<AuthPhoneBody> createState() => _AuthPhoneBodyState();
}

class _AuthPhoneBodyState extends State<AuthPhoneBody> {
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
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      child: Column(
        children: [
          const TextView(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            text: "Verify your \nphone number",
            textAlign: TextAlign.center,
            textColor: Colors.black,
            textStyle: FontWeight.bold,
            textSize: 24,
          ),
          const TextView(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            text:
                "We have sent you an SMS with a code to \nnumber +84 905070017",
            textAlign: TextAlign.center,
            textColor: Colors.grey,
            textSize: 14,
          ),
          PhoneField(
            margin: const EdgeInsets.symmetric(vertical: 24),
            controller: phone,
            textCode: "+880",
            textNumber: "1313670655",
            hintCode: "+880",
            hintNumber: "Enter the last 10 digits",
          ),
          PasswordField(
            hint: "Enter your password",
            controller: password,
          ),
          Button(
            width: 200,
            text: "Login",
            borderRadius: 12,
            onPressed: () {
              Navigator.pushNamed(context, AuthOtpPage.route);
            },
          ),
        ],
      ),
    );
  }
}
