import 'package:flutter/material.dart';

import '../../../../index.dart';

class AboutFragmentBuilder extends StatefulWidget {
  final bool isFromWelcome;
  final AboutFragmentType type;

  const AboutFragmentBuilder({
    Key? key,
    required this.isFromWelcome,
    required this.type,
  }) : super(key: key);

  @override
  State<AboutFragmentBuilder> createState() => _AboutFragmentBuilderState();
}

class _AboutFragmentBuilderState extends State<AboutFragmentBuilder> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case AboutFragmentType.privacy:
      case AboutFragmentType.terms:
      case AboutFragmentType.abouts:
        return const AboutPrivacyFragment();
    }
  }
}
