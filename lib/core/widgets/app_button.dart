import 'package:appeler/core/app_constants/app_color.dart';
import 'package:flutter/material.dart';

class AppCommonButton extends StatelessWidget {
  const AppCommonButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.color,
  });

  final String title;
  final Color? color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 120,
      child: MaterialButton(
        color: color,
        onPressed: onPressed,
        child: Text(title, style: const TextStyle(color: kWhiteColor)),
      ),
    );
  }
}
