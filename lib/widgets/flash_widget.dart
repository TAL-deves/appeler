import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class FlashWidget extends StatefulWidget {
  final SizeConfig? sizeConfig;

  const FlashWidget({
    Key? key,
    this.sizeConfig,
  }) : super(key: key);

  @override
  State<FlashWidget> createState() => _FlashWidgetState();
}

class _FlashWidgetState extends State<FlashWidget> {
  var _customOpacity = 0.0;

  @override
  Widget build(BuildContext context) {
    final config = widget.sizeConfig;
    return Container(
      height: config?.px(190) ?? 190,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            curve: Curves.bounceOut,
            onEnd: () {
              setState(() {
                _customOpacity = 1;
              });
            },
            tween: Tween(begin: 30, end: 140),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Image.asset(
                'assets/png/logo.png',
                height: config?.px(value) ?? value,
                width: config?.px(value) ?? value,
              );
            },
          ),
          SizedBox(height: config?.px(5) ?? 5),
          AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: _customOpacity,
            child: Text(
              LocaleKeys.appName.tr(),
              style: TextStyle(
                  fontSize: config?.px(25) ?? 25, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
