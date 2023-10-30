import 'package:appeler/core/sdk/ui/meeting/index.dart';
import 'package:auth_management/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    widget.homeController?.verifyId(id).then((value) {
      if (value) {
        joinButton.setEnabled(true);
        errorController.setVisibility(false);
      } else {
        joinButton.setEnabled(false);
        errorController.setVisibility(true);
      }
    });
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
          // AppCurrentNavigator.of(context).goHome(
          //   MeetingActivity.route.withParent("app"),
          //   extra: {
          //     "data": info,
          //     "HomeController": context.read<HomeController>(),
          //   },
          // );
          AppCurrentNavigator.of(context).goHome(
            ARTCMeetingPage.route.withParent("app"),
            extra: {
              "data": ARTCMeetingInfo(
                roomId: info.id,
                currentUid: AuthHelper.uid,
                isCameraOn: info.isCameraOn,
                isMicrophoneOn: !info.isMuted,
                isShareScreen: info.isShareScreen,
                isSilent: info.isSilent,
                cameraType: info.cameraType,
                email: AuthHelper.defaultUser?.email,
                name: AuthHelper.defaultUser?.displayName,
                phone: AuthHelper.defaultUser?.phoneNumber,
                photo: AuthHelper.defaultUser?.photoURL,
              ),
              "HomeController": context.read<HomeController>(),
            },
          );
        },
      ),
    );
  }
}
