import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';

import '../../../../index.dart';

class HomeFragmentMobile extends StatefulWidget {
  final HomeController controller;
  final TextEditingController codeController;
  final OnViewClickListener onCreateMeet,
      onJoinMeet,
      onScheduleMeet,
      onJoin,
      onLogout;
  final OnViewChangeListener onCopyOrShare;

  const HomeFragmentMobile({
    Key? key,
    required this.controller,
    required this.codeController,
    required this.onCreateMeet,
    required this.onJoinMeet,
    required this.onScheduleMeet,
    required this.onJoin,
    required this.onLogout,
    required this.onCopyOrShare,
  }) : super(key: key);

  @override
  State<HomeFragmentMobile> createState() => _HomeFragmentMobileState();
}

class _HomeFragmentMobileState extends State<HomeFragmentMobile> {
  late HomeController controller = widget.controller;
  late TextEditingController codeController = widget.codeController;
  late int index = 0;
  String? oldRoomId;

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      widthMax: 420,
      children: [
        LinearLayout(
          flex: 1,
          layoutGravity: LayoutGravity.center,
          children: [
            const Spacer(flex: 3),
            HomeSlider(
              onCreateMeet: widget.onCreateMeet,
              onJoinMeet: widget.onJoinMeet,
              onScheduleMeet: widget.onScheduleMeet,
            ),
            const Spacer(),
            const HomeIndicator(
              itemCount: 3,
              activeIndex: 1,
            ),
            const Spacer(),
          ],
        ),
        MeetingIdWithButtons(
          controller: controller,
          codeController: codeController,
          onJoin: widget.onJoin,
          onCopyOrShare: widget.onCopyOrShare,
          onLogout: widget.onLogout,
        ),
      ],
    );
  }
}
