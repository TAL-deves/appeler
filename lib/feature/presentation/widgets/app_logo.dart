import 'package:flutter/material.dart';

import '../../../index.dart';

class AppLogo extends StatefulWidget {
  final EdgeInsetsGeometry? logoPadding;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? subtitleMargin;
  final bool titleAllCaps;
  final TextStyle titleStyle;
  final Color? titleColor;
  final double? titleSize;
  final FontWeight? titleWeight;
  final double? titleExtraSize;

  final String? subtitle;
  final TextStyle? subtitleStyle;
  final Color? subtitleColor;
  final double? subtitleSize;
  final FontWeight? subtitleWeight;
  final double? subtitleExtraSize;
  final double logoSize;
  final Color? logoColor;

  const AppLogo({
    Key? key,
    this.logoPadding,
    this.titlePadding,
    this.subtitleMargin,
    this.titleAllCaps = true,
    this.titleStyle = const TextStyle(),
    this.titleColor,
    this.titleSize = 32,
    this.titleWeight = FontWeight.bold,
    this.titleExtraSize,
    this.subtitle,
    this.subtitleStyle,
    this.subtitleColor,
    this.subtitleSize,
    this.subtitleWeight,
    this.subtitleExtraSize,
    this.logoSize = 90,
    this.logoColor,
  }) : super(key: key);

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: widget.logoPadding,
          child: Image.asset(
            AppInfo.logo,
            width: widget.logoSize,
            height: widget.logoSize,
            color: widget.logoColor ?? AppColors.primary,
          ),
        ),
        Container(
          margin: widget.titlePadding ?? const EdgeInsets.only(top: 16),
          child: Text(
            widget.titleAllCaps ? AppInfo.name.toUpperCase() : AppInfo.name,
            textAlign: TextAlign.center,
            style: widget.titleStyle.copyWith(
              color: widget.titleColor ?? AppColors.secondary,
              fontSize: widget.titleSize,
              fontWeight: widget.titleWeight,
              letterSpacing: widget.titleExtraSize,
            ),
          ),
        ),
        Container(
          padding: widget.subtitleMargin ??
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
          child: Text(
            widget.subtitle ?? "",
            textAlign: TextAlign.center,
            style: (widget.subtitleStyle ?? widget.titleStyle).copyWith(
              color: widget.subtitleColor,
              fontSize: widget.subtitleSize ?? ((widget.titleSize ?? 1) * 0.5),
              fontWeight: widget.subtitleWeight,
              letterSpacing: widget.subtitleExtraSize,
            ),
          ),
        ),
      ],
    );
  }
}
