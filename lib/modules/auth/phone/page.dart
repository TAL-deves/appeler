import 'package:flutter/material.dart';

import '../../../index.dart';

class AuthPhonePage extends StatelessWidget {

  static const route = 'auth_phone';

  const AuthPhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthPhoneBody(
        onLogin: (phone, pass) async{
          //Navigator.of(context).pushReplacementNamed(homeScreenRoute);
          print('on login: ${phone.digits}   $pass');
          AuthManagementUseCase.login(phoneNumber: phone.digits, password: pass);
        },
      ),
    );
  }
}
