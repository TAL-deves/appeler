import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../index.dart';

class PrepareFragment extends StatefulWidget {
  final MeetingInfo info;
  final OnPrepare onPrepare;

  const PrepareFragment({
    Key? key,
    required this.info,
    required this.onPrepare,
  }) : super(key: key);

  @override
  State<PrepareFragment> createState() => _PrepareFragmentState();
}

class _PrepareFragmentState extends State<PrepareFragment> {
  late bool isCameraOn = widget.info.isCameraOn;
  late bool isMuted = widget.info.isMuted;
  bool shareScreenEnabled = false;
  late TextEditingController code = TextEditingController();

  @override
  void initState() {
    code.text = widget.info.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      layoutGravity: LayoutGravity.center,
      background: Colors.white10,
      padding: 40,
      children: [
        LinearLayout(
          layoutGravity: LayoutGravity.center,
          children: [
            MeetingCamera(
              width: 200,
              height: 300,
              avatar: AppContents.prepareMeetingAvatar,
              initialCameraEnable: isCameraOn,
              initialMuteEnable: isMuted,
              cameraType: widget.info.cameraType,
              onCameraStateChange: (value) {
                isCameraOn = value;
              },
              onMicroStateChange: (value) {
                isMuted = value;
              },
            ),
            const SizedBox(height: 24),
            ShareScreenButtonForPrepareBody(
              onPressed: (){
                setState(() { shareScreenEnabled = !shareScreenEnabled; });
              },
              isEnabled: shareScreenEnabled,
            ),
          ],
        ),
        LinearLayout(
          paddingTop: 40,
          layoutGravity: LayoutGravity.center,
          children: [
            MeetingIdField(
              controller: code,
              icon: Icons.share_outlined,
              onCopyOrShare: (value) => Share.share(
                widget.info.id,
                subject: "Let's go to meeting ... ",
              ),
            ),
            AppIconButton(
              width: 150,
              borderRadius: 50,
              text: "Join",
              icon: Icons.videocam_outlined,
              margin: const EdgeInsets.only(top: 40),
              onClick: (context) => widget.onPrepare(
                context,
                widget.info.attach(
                  isCameraOn: isCameraOn,
                  isMuted: isMuted,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
