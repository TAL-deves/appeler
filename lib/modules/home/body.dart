import 'package:flutter/material.dart';

import '../../../widgets/text_view.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TextView(
      text: "Home",
      textSize: 42,
      textAlign: TextAlign.center,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
