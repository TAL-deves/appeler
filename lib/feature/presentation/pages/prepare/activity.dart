import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

typedef OnPrepare = Function(BuildContext context, MeetingInfo info);

class PrepareActivity extends StatefulWidget {
  static const String route = "prepare";
  static const String title = "Prepare";

  final HomeController? homeController;
  final String? meetingId;

  const PrepareActivity({
    Key? key,
    required this.meetingId,
    required this.homeController,
  }) : super(key: key);

  @override
  State<PrepareActivity> createState() => _PrepareActivityState();
}

class _PrepareActivityState extends State<PrepareActivity> {
  late TextEditingController code;
  late ButtonController joinButton;
  late TextViewController errorController;
  late String? meetingId = widget.meetingId;
  late bool isSilent = false;
  late bool isFrontCamera = true;
  var joined = false;

  @override
  void initState() {
    code = TextEditingController();
    joinButton = ButtonController();
    errorController = TextViewController();
    _verifyId(meetingId);
    super.initState();
  }

  @override
  void dispose() {
    if (!joined && widget.meetingId != null) {
      locator<MeetingHandler>().removeStatus(widget.meetingId!);
    }
    code.dispose();
    super.dispose();
  }

  void _verifyId(String? id) {
    joinButton.setEnabled(false);
    if (id.isValid) {
      FirebaseFirestore.instance
          .collection("group-chat-rooms")
          .doc(id)
          .get()
          .then((value) {
        if (value.exists) {
          joinButton.setEnabled(true);
          errorController.setVisibility(ViewVisibility.gone);
        } else {
          joinButton.setEnabled(false);
          errorController.setVisibility(ViewVisibility.visible);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: kIsWeb ? null : widget.meetingId,
      titleCenter: true,
      body: PrepareFragment(
        errorController: errorController,
        buttonController: joinButton,
        codeController: code,
        isValidId: false,
        info: MeetingInfo(
          id: meetingId ?? "",
          isSilent: isSilent,
          cameraType: isFrontCamera ? CameraType.front : CameraType.back,
        ),
        onPrepare: (context, info) async {
          joined = true;
          AppCurrentNavigator.of(context).goHome(
            MeetingActivity.route.withParent("app"),
            extra: {
              "data": info,
              "HomeController": context.read<HomeController>(),
            },
          );
        },
      ),
    );
  }
}
