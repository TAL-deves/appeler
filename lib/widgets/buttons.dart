import 'package:flutter/material.dart';

import '../index.dart';

class AppDeepBlueButton extends StatelessWidget {
  const AppDeepBlueButton({
    super.key,
    this.width,
    this.height,
    required this.title,
    this.titleSize,
    required this.onPressed,
    this.customBodyColor,
    this.customTextColor,
    this.customRadius,
  });

  final String title;
  final double? titleSize;
  final Function()? onPressed;
  final double? width, height, customRadius;
  final Color? customBodyColor, customTextColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 35,
      width: width ?? 250,
      child: Material(
        color: customBodyColor ?? kLoginTextButtonColor,
        borderRadius: BorderRadius.circular(customRadius ?? 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(customRadius ?? 20),
          onTap: onPressed,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: customTextColor ?? kPrimaryColor,
                  fontSize: titleSize ?? 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class AppImageButton extends StatelessWidget {
  const AppImageButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.imagePath,
    this.textSize,
    required this.sizeConfig,
  });

  final String title, imagePath;
  final double? textSize;
  final Function()? onPressed;

  final SizeConfig? sizeConfig;

  @override
  Widget build(BuildContext context) {
    final config = sizeConfig;
    return SizedBox(
      height: config?.px(40) ?? 40,
      width: config?.px(300) ?? 300,
      child: Material(
        color: kTextFieldColor,
        borderRadius: BorderRadius.circular(config?.px(20) ?? 20),
        child: InkWell(
            borderRadius: BorderRadius.circular(config?.px(20) ?? 20),
            splashColor: kLightYellowColor,
            onTap: onPressed,
            child: Stack(
              children: [
                Positioned(
                  left: config?.px(5) ?? 5,
                  top: config?.px(3) ?? 3,
                  bottom: config?.px(3) ?? 3,
                  child: Image.asset(
                    imagePath,
                    height: config?.px(30) ?? 30,
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: kLoginTextButtonColor,
                        fontSize: textSize ?? config?.px(14) ?? 14,
                      ),
                      textAlign: TextAlign.center,
                    ))
              ],
            )),
      ),
    );
  }
}

class IconWithTextButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool disableMode;
  final Function() onPressed;

  const IconWithTextButton({
    Key? key,
    required this.title,
    required this.icon,
    this.disableMode = true,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed.call();
        if (disableMode) Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 24),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppCommonTextButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double textSize;
  final Function()? onPressed;

  const AppCommonTextButton({
    Key? key,
    required this.text,
    this.textColor,
    this.textSize = 16,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? color,
            fontSize: textSize,
          ),
        ),
      ),
    );
  }
}
