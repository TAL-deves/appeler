import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy/extensions.dart';
import 'package:flutter_androssy/widgets.dart';

import 'fragment.dart';
import 'meeting_info.dart';

class ARTCMeetingPage extends StatefulWidget {
  static const String route = "meeting";
  static const String title = "Meeting";

  final ARTCMeetingInfo? data;

  const ARTCMeetingPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ARTCMeetingPage> createState() => _ARTCMeetingPageState();
}

class _ARTCMeetingPageState extends State<ARTCMeetingPage> {
  late ARTCMeetingInfo info =
      widget.data ?? ARTCMeetingInfo(roomId: "", currentUid: "");
  late bool isSilent = info.isSilent;
  late bool isFrontCamera = info.isFrontCamera;
  late bool isScreenShare = info.isShareScreen;

  final globalKey = GlobalKey<ARTCMeetingSegmentState>();

  @override
  void initState() {
    silent();
    super.initState();
  }

  void silent() {
    globalKey.currentState?.onSilent(isSilent);
  }

  void switchCamera() {
    globalKey.currentState?.onSwitchCamera(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: LinearLayout(
          orientation: Axis.vertical,
          width: double.infinity,
          widthMax: 1400,
          children: [
            StackLayout(
              width: double.infinity,
              height: kToolbarHeight,
              children: [
                IconView(
                  padding: 8,
                  size: 40,
                  positionType: ViewPositionType.leftFlex,
                  icon: Icons.message_outlined,
                  tint: context.primaryColor,
                  background: Colors.transparent,
                  visibility: !kIsWeb,
                ),
                LinearLayout(
                  positionType: ViewPositionType.center,
                  layoutGravity: LayoutGravity.center,
                  children: [
                    RawIconView(
                      icon: Icons.groups,
                      tint: context.primaryColor,
                      size: 24,
                    ),
                    const TextView(
                      text: "Appeler",
                      textColor: Colors.black,
                    ),
                  ],
                ),
                LinearLayout(
                  visibility: !kIsWeb,
                  positionType: ViewPositionType.rightFlex,
                  orientation: Axis.horizontal,
                  crossGravity: CrossAxisAlignment.center,
                  children: [
                    IconView(
                      padding: 8,
                      size: 40,
                      icon: isSilent
                          ? Icons.volume_off_outlined
                          : Icons.volume_up_outlined,
                      tint: context.primaryColor,
                      onClick: (context) {
                        isSilent = !isSilent;
                        setState(silent);
                      },
                    ),
                    IconView(
                      padding: 8,
                      size: 40,
                      icon: isFrontCamera
                          ? Icons.camera_front_outlined
                          : Icons.camera_rear_outlined,
                      tint: context.primaryColor,
                      onClick: (context) {
                        isFrontCamera = !isFrontCamera;
                        setState(switchCamera);
                      },
                    )
                  ],
                )
              ],
            ),
            Expanded(
              child: ARTCMeetingSegment(
                key: globalKey,
                info: info,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
