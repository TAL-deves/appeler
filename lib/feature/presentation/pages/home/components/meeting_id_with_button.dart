import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/widgets.dart';

import '../../../../../index.dart';

class MeetingIdWithButtons extends StatefulWidget {
  final HomeController controller;

  final TextEditingController codeController;
  final OnViewClickListener onJoin, onLogout, onDeleteAccount;
  final OnViewChangeListener onCopyOrShare;
  final ButtonController joinButton;

  const MeetingIdWithButtons({
    super.key,
    required this.controller,
    required this.codeController,
    required this.onJoin,
    required this.onLogout,
    required this.onCopyOrShare,
    required this.onDeleteAccount,
    required this.joinButton,
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
          icon: Icons.share_rounded,
          iconVisible: index == 0,
          onCopyOrShare: widget.onCopyOrShare,
        ),
        Button(
          controller: widget.joinButton,
          ripple: 10,
          width: double.infinity,
          text: buttonName,
          fontWeight: FontWeight.bold,
          borderRadius: 25,
          marginTop: 24,
          enabled: widget.codeController.text.isValid,
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
          marginTop: 12,
          paddingVertical: 12,
          paddingHorizontal: 24,
          onClick: (context) => onAlertDialog(
            context: context,
            title: "Logout",
            description: "Are you sure you want to logout from your account?",
            onAction: widget.onLogout,
          ),
        ),
        TextView(
          text: "Delete Account",
          borderRadius: 25,
          paddingVertical: 12,
          paddingHorizontal: 24,
          textColor: Colors.redAccent,
          onClick: (context) => onAlertDialog(
            context: context,
            title: "Delete Account",
            description: "Are you sure you want to delete your account?",
            onAction: widget.onDeleteAccount,
          ),
        ),
      ],
    );
  }

  void onAlertDialog({
    required BuildContext context,
    required String title,
    required String description,
    OnViewClickListener? onAction,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(title),
          content: Text(description),
          actions: [
            TextView(
              widthMin: 80,
              textAlign: TextAlign.center,
              ripple: 5,
              text: "Cancel",
              paddingHorizontal: 16,
              paddingVertical: 8,
              borderRadius: 8,
              textColor: AppColors.primary,
              background: AppColors.primary.withAlpha(50),
              onClick: (context) => Navigator.pop(context),
            ),
            TextView(
              textAlign: TextAlign.center,
              widthMin: 80,
              ripple: 5,
              text: "OK",
              textColor: Colors.white,
              paddingHorizontal: 16,
              paddingVertical: 8,
              borderRadius: 8,
              background: AppColors.primary,
              onClick: (context) {
                onAction?.call(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String get buttonName => index == 0
      ? "Join"
      : index == 1
          ? "Join"
          : "Schedule";
}
