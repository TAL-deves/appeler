import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

class AppIconButton extends StatelessWidget {
  final double? width;
  final double borderRadius;
  final String text;
  final IconData icon;
  final OnViewClickListener? onClick;
  final EdgeInsets? margin;
  final bool iconVisible;

  const AppIconButton({
    Key? key,
    required this.text,
    required this.icon,
    this.onClick,
    this.margin,
    this.width = 120,
    this.borderRadius = 16,
    this.iconVisible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StackLayout(
      width: width,
      margin: 16,
      marginTop: margin?.top,
      marginBottom: margin?.bottom,
      marginStart: margin?.left,
      marginEnd: margin?.right,
      marginHorizontal: margin?.horizontal,
      marginVertical: margin?.vertical,
      paddingHorizontal: 16,
      paddingVertical: 12,
      background: Theme.of(context).primaryColor,
      borderRadius: borderRadius,
      onClick: onClick,
      children: [
        RawTextView(
          text: text,
          textColor: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        IconView(
          visibility: iconVisible,
          icon: icon,
          padding: 0,
          background: Colors.transparent,
          size: 24,
          tint: Colors.white,
          positionType: ViewPositionType.centerStart,
        ),
      ],
    );
  }
}
