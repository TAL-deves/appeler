import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

class OAuthButton extends StatelessWidget {
  final String text;
  final Color background;
  final String icon;
  final OnViewClickListener onClick;

  const OAuthButton({
    Key? key,
    required this.text,
    required this.background,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StackLayout(
      background: background,
      gravity: Alignment.center,
      borderRadiusBR: 25,
      borderRadiusTL: 25,
      paddingHorizontal: 24,
      paddingVertical: 14,
      marginTop: 24,
      onClick: onClick,
      children: [
        RawText(
          text: text,
          textSize: 16,
          textColor: Colors.white,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
