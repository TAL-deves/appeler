import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';

import '../../../../../index.dart';

class AboutPrivacyFragment extends StatelessWidget {
  const AboutPrivacyFragment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      scrollable: true,
      children: [
        AppDetailsView(
          title: PrivacyContent.none.title,
          body: PrivacyContent.none.body,
          paragraphs: PrivacyContent.values
              .getRange(1, PrivacyContent.values.length)
              .map((e) {
            return Paragraph(title: e.title, body: e.body);
          }).toList(),
          justifyMode: true,
          margin: const EdgeInsets.symmetric(vertical: 12),
        ),
      ],
    );
  }
}
