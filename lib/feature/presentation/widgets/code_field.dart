import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';

import '../../../index.dart';

class MeetingIdField extends StatelessWidget {
  final String? initialValue;
  final String hint;
  final dynamic icon;
  final bool iconVisible;
  final Function(String)? onCopyOrShare;
  final TextEditingController controller;

  const MeetingIdField({
    Key? key,
    this.hint = "Meeting ID",
    this.initialValue,
    this.icon,
    this.iconVisible = true,
    this.onCopyOrShare,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) controller.text = initialValue!;
    return Stack(
      alignment: Alignment.center,
      children: [
        TextField(
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
            label: RawTextView(
              text: "Meet ID",
              textColor: AppColors.secondary,
              fontWeight: FontWeight.bold,
              textSize: 16,
            ),
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        IconView(
          visibility: icon != null && iconVisible
              ? ViewVisibility.visible
              : ViewVisibility.gone,
          padding: 8,
          background: Colors.transparent,
          borderRadius: 8,
          position: const ViewPosition(right: 4),
          icon: icon ?? Icons.copy_all,
          tint: Colors.grey.withAlpha(200),
          onClick: (context) => onCopyOrShare?.call(controller.text),
        ),
      ],
    );
  }
}
