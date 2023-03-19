import 'package:flutter/material.dart';
import '../api/auth_management.dart';
import 'body.dart';

const authScreenRoute = 'authScreenRoute';

class AuthPhonePage extends StatelessWidget {

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
