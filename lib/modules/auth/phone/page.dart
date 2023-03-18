import 'package:appeler/modules/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/action_button.dart';
import '../api/auth_management.dart';
import 'body.dart';

class AuthPhonePage extends StatelessWidget {
  static const String route = "auth_phone";
  static const String title = "Phone Authentication";

  const AuthPhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthPhoneBody(
        onLogin: (phone, pass) async{
          Navigator.of(context).pushReplacementNamed(homeScreenRoute);
          //return AuthManagementUseCase.login(phoneNumber: phone.digits, password: pass);
        },
      ),
    );
  }
}
