import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/widgets.dart';

class TileButton extends StatelessWidget {
  final String text;
  final dynamic icon;
  final OnViewClickListener? onClick;

  const TileButton({
    super.key,
    this.text = "",
    this.icon,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      orientation: Axis.horizontal,
      onClick: onClick,
      ripple: 5,
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
          visibility:
              text.isValid ? ViewVisibility.visible : ViewVisibility.gone,
        ),
        if (icon != null)
          IconView(
            icon: icon,
            padding: 4,
            borderRadius: 0,
          ),
      ],
    );
  }
}
