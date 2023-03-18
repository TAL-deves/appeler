import 'package:flutter/material.dart';

class OtpField extends StatefulWidget {
  final OtpEditingController? controller;
  final double? width;
  final String? text;
  final String hint;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const OtpField({
    Key? key,
    this.controller,
    this.width,
    this.text,
    this.hint = "Code",
    this.borderRadius = 0,
    this.margin,
  }) : super(key: key);

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  late OtpEditingController controller;

  @override
  void initState() {
    controller = widget.controller ?? OtpEditingController();
    controller.text = widget.text ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: widget.margin ?? const EdgeInsets.only(bottom: 24),
      width: double.infinity,
      child: SizedBox(
        width: widget.width,
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: widget.hint,
            isDense: true,
            border: widget.borderRadius > 0
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius))
                : null,
          ),
        ),
      ),
    );
  }
}

class OtpEditingController extends TextEditingController {}
