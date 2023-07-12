import 'package:flutter/material.dart';

class AppDetailsView extends StatelessWidget {
  final String title;
  final String? body;
  final List<Paragraph>? paragraphs;
  final bool justifyMode;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const AppDetailsView({
    Key? key,
    required this.title,
    this.body,
    this.paragraphs,
    this.justifyMode = false,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 35,
          ),
      child: Column(
        children: [
          if ((body ?? "").isNotEmpty)
            Text(
              body ?? "",
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          if ((paragraphs ?? []).isNotEmpty)
            DottedTexts(
              paragraphs: paragraphs ?? [],
              style: const ParagraphStyle(
                textSize: 14,
                textColor: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}

class DottedTexts extends StatelessWidget {
  final ParagraphStyle style;
  final List<Paragraph> paragraphs;

  const DottedTexts({
    Key? key,
    required this.paragraphs,
    this.style = const ParagraphStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: paragraphs.map((e) {
        return ParagraphView(
          paragraph: e,
          style: style,
        );
      }).toList(),
    );
  }
}

class Paragraph {
  final String title;
  final String body;

  Paragraph({
    this.title = "",
    this.body = "",
  });
}

class ParagraphView extends StatelessWidget {
  final Paragraph paragraph;
  final ParagraphStyle style;

  const ParagraphView({
    Key? key,
    required this.paragraph,
    this.style = const ParagraphStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DottedTextView(
            text: paragraph.title,
            textSize: style.textSize,
            textStyle: FontWeight.bold,
          ),
          Container(
            padding: EdgeInsets.only(
              top: 4,
              left: style.textSize,
            ),
            child: Text(
              paragraph.body,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.black,
                fontSize: style.textSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ParagraphStyle {
  final Color textColor;
  final double textSize;

  const ParagraphStyle({
    this.textColor = Colors.black,
    this.textSize = 14,
  });
}

class DottedTextView extends StatelessWidget {
  final String text;
  final double textSize;
  final FontWeight? textStyle;
  final TextAlign? textAlign;

  const DottedTextView({
    Key? key,
    required this.text,
    this.textSize = 14,
    this.textStyle,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bulletSize = textSize * 0.5;
    final bulletPadding = textSize * 0.33;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          width: bulletSize,
          height: bulletSize,
          margin: EdgeInsets.only(
            right: bulletPadding * 1.5,
            top: bulletPadding,
            bottom: bulletPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Expanded(
          child: Text(
            text,
            textAlign: textAlign,
            style: TextStyle(
              color: Colors.black,
              fontSize: textSize,
              fontWeight: textStyle,
            ),
          ),
        ),
      ],
    );
  }
}
