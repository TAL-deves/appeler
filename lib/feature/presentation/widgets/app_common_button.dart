import 'package:flutter/material.dart';
import 'package:flutter_androssy/services.dart';
import 'package:flutter_androssy/widgets.dart';

class AppCommonButton extends StatelessWidget {
  final double? width;
  final String text;
  final Color? textColor;
  final double? textSize;
  final Color? background;
  final double? borderRadius;
  final double? borderRadiusBR;
  final double? borderRadiusTL;
  final int? flex;
  final bool rippleMode;
  final bool tweenCornerMode;
  final OnViewClickListener? onClick;

  const AppCommonButton({
    super.key,
    this.width,
    required this.text,
    this.textColor = Colors.white,
    this.textSize = 16,
    this.background,
    this.borderRadius,
    this.borderRadiusBR = 50,
    this.borderRadiusTL = 50,
    this.flex,
    this.rippleMode = true,
    this.tweenCornerMode = false,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      absorbMode: true,
      heightMin: 40,
      width: width,
      flex: flex,
      background: background,
      borderRadius: borderRadius,
      borderRadiusBR: tweenCornerMode ? borderRadiusBR : null,
      borderRadiusTL: tweenCornerMode ? borderRadiusTL : null,
      gravity: Alignment.center,
      rippleColor: Colors.black.withAlpha(100),
      text: text,
      textColor: textColor,
      textSize: textSize,
      textFontWeight: FontWeight.w500,
      onClick: onClick,
    );
  }
}
