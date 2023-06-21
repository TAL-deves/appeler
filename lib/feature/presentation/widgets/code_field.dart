import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/widgets.dart';

import '../../../index.dart';

class MeetingIdField extends StatefulWidget {
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
  State<MeetingIdField> createState() => _MeetingIdFieldState();
}

class _MeetingIdFieldState extends State<MeetingIdField> {
  late IconViewController icon = IconViewController();

  @override
  void initState() {
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
    }
    widget.controller.addListener(() {
      setState(() {
        icon.setVisibility(
          widget.controller.text.isValid
              ? ViewVisibility.visible
              : ViewVisibility.gone,
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            hintText: widget.hint,
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
          controller: icon,
          visibility: widget.icon != null &&
                  widget.iconVisible &&
                  widget.controller.text.isNotEmpty
              ? ViewVisibility.visible
              : ViewVisibility.gone,
          padding: 8,
          background: Colors.transparent,
          borderRadius: 8,
          position: const ViewPosition(right: 4),
          icon: widget.icon ?? Icons.copy_all,
          tint: Colors.grey.withAlpha(200),
          onClick: (context) =>
              widget.onCopyOrShare?.call(widget.controller.text),
        ),
      ],
    );
  }
}
