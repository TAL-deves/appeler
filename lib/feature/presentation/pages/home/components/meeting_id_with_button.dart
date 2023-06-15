import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';

import '../../../../../index.dart';

class MeetingIdWithButtons extends StatefulWidget {
  final HomeController controller;

  final TextEditingController codeController;
  final OnViewClickListener onJoin, onLogout;
  final OnViewChangeListener onCopyOrShare;

  const MeetingIdWithButtons({
    super.key,
    required this.controller,
    required this.codeController,
    required this.onJoin,
    required this.onLogout,
    required this.onCopyOrShare,
  });

  @override
  State<MeetingIdWithButtons> createState() => _MeetingIdWithButtonsState();
}

class _MeetingIdWithButtonsState extends State<MeetingIdWithButtons> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      flex: 1,
      layoutGravity: LayoutGravity.center,
      paddingHorizontal: 50,
      children: [
        MeetingIdField(
          controller: widget.codeController,
          icon: Icons.copy_all,
          iconVisible: index == 0,
          onCopyOrShare: widget.onCopyOrShare,
        ),
        Button(
          ripple: 10,
          width: 120,
          text: buttonName,
          borderRadius: 25,
          marginTop: 24,
          onClick: (context) {
            if (index == 0 || index == 1) {
              if (widget.codeController.text.isNotEmpty) {
                widget.onJoin(context);
              }
            } else {}
          },
        ),
        TextView(
          text: "Logout",
          borderRadius: 25,
          marginTop: 24,
          onClick: widget.onLogout,
        ),
      ],
    );
  }

  String get buttonName => index == 0
      ? "Join"
      : index == 1
          ? "Join"
          : "Schedule";
}
