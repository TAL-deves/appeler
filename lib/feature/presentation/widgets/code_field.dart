import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

import '../../../index.dart';

class MeetingIdField extends StatelessWidget {
  final String? initialValue;
  final String hint;
  final TextEditingController controller;

  const MeetingIdField({
    Key? key,
    this.hint = "Meeting ID",
    this.initialValue,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) controller.text = initialValue!;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withAlpha(50),
            width: 1,
          ),
        ),
        focusColor: AppColors.primary.withAlpha(50),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withAlpha(50),
            width: 1.5,
          ),
        ),
        isDense: false,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: TextStyle(
          color: AppColors.primary,
        ),
        label: RawText(
          text: "Meet ID",
          textColor: AppColors.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
