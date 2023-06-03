import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

class OAuthButton extends StatelessWidget {
  final String text;
  final Color? background;
  final dynamic icon;
  final OnViewClickListener? onClick;

  const OAuthButton({
    Key? key,
    required this.text,
    this.background,
    this.icon,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Button(
      background: background,
      gravity: Alignment.center,
      borderRadiusBR: 25,
      borderRadiusTL: 25,
      paddingHorizontal: 24,
      paddingVertical: 12,
      iconSize: 24,
      marginTop: 24,
      onClick: onClick,
      text: text,
      textSize: 16,
      textColor: Colors.white,
      fontWeight: FontWeight.w500,
      icon: icon,
      ripple: 10,
      iconColorEnabled: false,
      iconAlignment: IconAlignment.start,
    );
  }
}
