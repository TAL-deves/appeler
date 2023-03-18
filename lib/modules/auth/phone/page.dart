import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/action_button.dart';
import 'body.dart';

class AuthPhonePage extends StatelessWidget {
  static const String route = "auth_phone";
  static const String title = "Phone Authentication";

  const AuthPhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: ActionButton(
          icon: Icons.arrow_back,
          borderRadius: 25,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: const AuthPhoneBody(),
    );
  }
}
