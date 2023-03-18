import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final PasswordEditingController? controller;
  final String? text;
  final String hint;
  final EdgeInsetsGeometry? margin;

  const PasswordField({
    Key? key,
    this.controller,
    this.text,
    this.hint = "Password",
    this.margin,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late PasswordEditingController controller;

  @override
  void initState() {
    controller = widget.controller ?? PasswordEditingController();
    controller.text = widget.text ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.only(bottom: 24),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: widget.hint,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class PasswordEditingController extends TextEditingController {}
