import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../index.dart';

class HomePage extends StatelessWidget {
  static const String route = "home";
  static const String title = "Home";

  const HomePage({Key? key}) : super(key: key);

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
      body: const HomeBody(),
    );
  }
}
