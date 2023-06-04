import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

import '../../../index.dart';

class AppScreen extends StatelessWidget {
  final bool? autoLeading;
  final EdgeInsetsGeometry? padding;
  final Color? toolbarColor;
  final double elevation;
  final double? toolbarHeight;
  final Color? background;
  final String backgroundImage;
  final Color? statusBarColor;
  final Brightness statusBarBrightness;
  final String? title;
  final Color? titleColor;
  final double? titleExtraSize;
  final bool titleCenter;
  final double? titleSize;
  final TextStyle titleStyle;
  final FontWeight? titleWeight;
  final Widget body;
  final List<Widget>? actions;
  final OnViewBuilder? toolbar;
  final OnViewBuilder? onLeadingBuilder;

  const AppScreen({
    Key? key,
    this.autoLeading,
    this.background,
    this.backgroundImage = "",
    this.toolbarColor = Colors.transparent,
    this.elevation = 0.5,
    this.toolbarHeight,
    this.padding,
    this.statusBarColor,
    this.statusBarBrightness = Brightness.dark,
    this.title,
    this.titleCenter = false,
    this.titleColor = Colors.black,
    this.titleExtraSize,
    this.titleSize = 20,
    this.titleStyle = const TextStyle(),
    this.titleWeight,
    required this.body,
    this.actions,
    this.toolbar,
    this.onLeadingBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          // constraints: const BoxConstraints(
          //   maxWidth: 500,
          // ),
          child: ScreenView(
            key: key,
            authShowLeading: autoLeading ?? !kIsWeb,
            actions: actions,
            background: background ?? Colors.white,
            //backgroundImage: AppContents.backgroundCover,
            behindAppbar: true,
            behindBody: true,
            resizeToAvoidBottomInset: true,
            elevation: elevation,
            padding: padding,
            statusBarColor: statusBarColor,
            statusBarBrightness: statusBarBrightness,
            toolbarIconTint: AppColors.primary,
            title: title,
            titleCenter: titleCenter,
            titleColor: titleColor,
            titleExtraSize: titleExtraSize,
            titleSize: titleSize,
            titleStyle: titleStyle,
            titleWeight: titleWeight,
            toolbarColor: toolbarColor,
            toolbarHeight: toolbarHeight,
            onLeadingBuilder: onLeadingBuilder,
            onTitleBuilder: toolbar,
            body: Stack(
              alignment: Alignment.center,
              children: [
                const ImageView(
                  image: AppContents.backgroundCover1,
                  positionType: ViewPositionType.topStart,
                  width: 120,
                  scaleType: BoxFit.fill,
                  height: 120,
                ),
                const ImageView(
                  image: AppContents.backgroundCover2,
                  positionType: ViewPositionType.bottomEnd,
                  width: 120,
                  scaleType: BoxFit.fill,
                  height: 120,
                ),
                body,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
