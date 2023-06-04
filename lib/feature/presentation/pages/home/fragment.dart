import 'package:appeler/feature/presentation/pages/home/fragment_desktop.dart';
import 'package:appeler/feature/presentation/pages/home/fragment_mobile.dart';
import 'package:appeler/feature/presentation/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

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
  late int index = 0;
  String? oldRoomId;

  @override
  void initState() {
    controller = widget.controller;
    code = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: HomeFragmentMobile(
        controller: widget.controller,
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

  void onJoinMeet(BuildContext context) {}

  void onScheduleMeet(BuildContext context) {}

  void onJoin(BuildContext context) {
    Navigator.pushNamed(
      context,
      PrepareActivity.route,
      arguments: {
        "meeting_id": code.text,
        "HomeController": widget.controller,
      },
    );
  }

  void onLogout(BuildContext context) {
    controller.signOut().then((value) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthActivity.route,
        (route) => false,
        arguments: AuthFragmentType.signIn,
      );
    });
  }

  void onCopyOrShare(dynamic value) async {
    await ClipboardHelper.setText(
      value,
    );
  }
}
