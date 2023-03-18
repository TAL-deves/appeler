import 'package:flutter/material.dart';

import '../../../widgets/button.dart';
import '../../../widgets/password_field.dart';
import '../../../widgets/phone_field.dart';
import '../../../widgets/text_view.dart';

class AuthPhoneBody extends StatefulWidget {
  final Function(Number number, String password)? onLogin;

  const AuthPhoneBody({
    Key? key,
    this.onLogin,
  }) : super(key: key);

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
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            //textCode: "+880",
            //textNumber: "",
            hintCode: "+880",
            hintNumber: "Enter phone number",
          ),
          PasswordField(
            hint: "Enter your password",
            controller: password,
            //text: "123",
          ),
          Button(
            width: 200,
            text: "Login",
            borderRadius: 12,
            onPressed: () {
              widget.onLogin?.call(phone.number, password.text);
            },
            // onExecute: (){
            //   return widget.onLogin?.call(phone.number, password.text);
            // },
            //onExecute: widget.onLogin?.call(phone.number, password.text),
          ),
        ],
      ),
    );
  }
}
