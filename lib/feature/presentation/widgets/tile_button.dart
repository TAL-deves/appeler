import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/services.dart';
import 'package:flutter_androssy/widgets.dart';

class TileButton extends StatelessWidget {
  final String text;
  final dynamic icon;
  final double iconSize;
  final Color? tint;
  final OnViewClickListener? onClick;

  const TileButton({
    super.key,
    this.text = "",
    this.icon,
    this.iconSize = 24,
    this.tint,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      orientation: Axis.horizontal,
      onClick: onClick,
      rippleColor: Colors.black.withOpacity(0.05),
      height: 50,
      paddingHorizontal: 24,
      layoutGravity: LayoutGravity.center,
      crossGravity: CrossAxisAlignment.center,
      children: [
        TextView(
          textSize: 16,
          textColor: Colors.black,
          flex: 1,
          text: text,
          visibility: text.isValid,
        ),
        if (icon != null)
          IconView(
            icon: icon,
            borderRadius: 0,
            size: iconSize,
            tint: tint,
          ),
      ],
    );
  }
}
