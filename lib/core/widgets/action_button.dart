import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final double size;
  final double? borderRadius;
  final IconData icon;
  final Color? tint;
  final Color? background;
  final Function()? onPressed;

  const ActionButton({
    Key? key,
    required this.icon,
    this.borderRadius,
    this.tint,
    this.background,
    this.size = 40,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
          color: background,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius ?? 50),
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(
                icon,
                color: tint,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
