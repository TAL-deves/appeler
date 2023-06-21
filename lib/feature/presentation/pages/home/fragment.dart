import 'package:appeler/feature/presentation/pages/home/fragment_desktop.dart';
import 'package:appeler/feature/presentation/pages/home/fragment_mobile.dart';
import 'package:appeler/feature/presentation/pages/meeting_participant/activity.dart';
import 'package:appeler/feature/presentation/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../index.dart';

class HomeFragment extends StatefulWidget {
  final HomeController controller;

  const HomeFragment({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  late HomeController controller;
  late TextEditingController code;
  late ButtonController joinButton;
  late int index = 0;
  String? oldRoomId;

  @override
  void initState() {
    controller = widget.controller;
    code = TextEditingController();
    joinButton = ButtonController();
    code.addListener(() {
      joinButton.setEnabled(code.text.isValid);
    });
    super.initState();
  }

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: HomeFragmentMobile(
        controller: widget.controller,
        joinButton: joinButton,
        codeController: code,
        onCreateMeet: onCreateMeetingId,
        onJoinMeet: onJoinMeet,
        onScheduleMeet: onScheduleMeet,
        onJoin: onJoin,
        onLogout: onLogout,
        onCopyOrShare: onCopyOrShare,
      ),
      desktop: HomeFragmentDesktop(
        controller: widget.controller,
        joinButton: joinButton,
        codeController: code,
        onCreateMeet: onCreateMeetingId,
        onJoinMeet: onJoinMeet,
        onScheduleMeet: onScheduleMeet,
        onJoin: onJoin,
        onLogout: onLogout,
        onCopyOrShare: onCopyOrShare,
      ),
    );
  }

  void onCreateMeetingId(BuildContext context) {
    final roomId = controller.generateRoom(oldRoomId);
    oldRoomId = roomId;
    if (roomId != null) {
      setState(() {
        code.text = roomId;
      });
    }
  }

  void onJoinMeet(BuildContext context) {
    AppNavigator.of(context).go(
      MeetingParticipantActivity.route.withSlash,
    );
  }

  void onScheduleMeet(BuildContext context) {}

  void onJoin(BuildContext context) {
    AppNavigator.of(context).go(
      PrepareActivity.route.withSlash,
      extra: {
        "meeting_id": code.text,
        "HomeController": widget.controller,
      },
    );
    code.text = "";
    joinButton.setEnabled(code.text.isValid);
  }

  void onLogout(BuildContext context) => controller.signOut();

  void onCopyOrShare(dynamic value) async {
    if (value is String && value.isNotEmpty) {
      await ClipboardHelper.setText(
        value,
      );
      Fluttertoast.showToast(msg: "Copied code");
    }
  }
}
