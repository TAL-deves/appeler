import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';

import '../../../../index.dart';

class AboutActivity extends StatelessWidget {
  static const String title = "Abouts";
  static const String route = "/privacy_policy";
  final AboutFragmentType? type;

  const AboutActivity({
    Key? key,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      toolbarHeight: 0,
      body: SafeArea(
        child: LinearLayout(
          width: double.infinity,
          height: double.infinity,
          children: [
            const TextView(
              height: kToolbarHeight,
              textSize: 20,
              gravity: Alignment.center,
              textColor: Colors.black,
              text: "Privacy Policy",
            ),
            AboutFragmentBuilder(
              isFromWelcome: false,
              type: type ?? AboutFragmentType.abouts,
            ),
          ],
        ),
      ),
    );
  }
}

enum AboutFragmentType {
  abouts,
  privacy,
  terms,
}
