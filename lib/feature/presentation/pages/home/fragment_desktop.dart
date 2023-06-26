import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';

import '../../../../index.dart';

class HomeFragmentDesktop extends StatefulWidget {
  final HomeController controller;
  final TextEditingController codeController;
  final OnViewClickListener onCreateMeet,
      onJoinMeet,
      onScheduleMeet,
      onJoin,
      onLogout,
      onDeleteAccount;
  final OnViewChangeListener onCopyOrShare;
  final ButtonController joinButton;

  const HomeFragmentDesktop({
    Key? key,
    required this.controller,
    required this.codeController,
    required this.onCreateMeet,
    required this.onJoinMeet,
    required this.onScheduleMeet,
    required this.onJoin,
    required this.onCopyOrShare,
    required this.onLogout,
    required this.onDeleteAccount,
    required this.joinButton,
  }) : super(key: key);

  @override
  State<HomeFragmentDesktop> createState() => _HomeFragmentDesktopState();
}

class _HomeFragmentDesktopState extends State<HomeFragmentDesktop> {
  late HomeController controller = widget.controller;
  late TextEditingController codeController = widget.codeController;
  late int index = 0;
  String? oldRoomId;

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      widthMax: 1000,
      orientation: Axis.horizontal,
      children: [
        LinearLayout(
          flex: 1,
          layoutGravity: LayoutGravity.center,
          children: [
            HomeSlider(
              onCreateMeet: widget.onCreateMeet,
              onJoinMeet: widget.onJoinMeet,
              onScheduleMeet: widget.onScheduleMeet,
            ),
            const SizedBox(
              height: 40,
            ),
            const HomeIndicator(
              itemCount: 3,
              activeIndex: 1,
            ),
          ],
        ),
        MeetingIdWithButtons(
          controller: controller,
          joinButton: widget.joinButton,
          codeController: codeController,
          onJoin: widget.onJoin,
          onCopyOrShare: widget.onCopyOrShare,
          onLogout: widget.onLogout,
          onDeleteAccount: widget.onDeleteAccount,
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
