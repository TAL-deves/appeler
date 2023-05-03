import 'package:flutter/material.dart';

class AppCommonButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? textSize;
  final double width, height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin, padding;
  final Color? background;
  final Color borderColor;
  final double elevation;
  final MaterialStateProperty<Color?>? backgroundStateList;
  final VoidCallback? onClick;

  const AppCommonButton({
    Key? key,
    required this.text,
    this.textColor,
    this.textSize,
    this.width = double.infinity,
    this.height = 50,
    this.background,
    this.backgroundStateList,
    this.borderRadius = 0,
    this.elevation = 0,
    this.margin,
    this.padding,
    this.onClick,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: padding == null ? height : null,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
      ),
      child: ElevatedButton(
        onPressed: onClick,
        style: ButtonStyle(
          padding: height == 0 ? MaterialStateProperty.all(padding) : null,
          textStyle: textColor != null
              ? MaterialStateProperty.all<TextStyle>(
                  TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: textSize ?? 18,
                  ),
                )
              : null,
          elevation: MaterialStateProperty.all(elevation),
          backgroundColor: backgroundStateList ??
              (background != null
                  ? MaterialStateProperty.all(background)
                  : null),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: textSize ?? 18,
          ),
        ),
      ),
    );
  }
}
