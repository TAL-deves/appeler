import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';

import '../../index.dart';

class MeetingCamera extends StatefulWidget {
  final double width, height;
  final bool initialCameraEnable;
  final bool initialMuteEnable;
  final CameraType cameraType;
  final dynamic avatar;
  final Function(bool isCameraOn) onCameraStateChange;
  final Function(bool isMicroOn) onMicroStateChange;

  const MeetingCamera({
    Key? key,
    this.initialCameraEnable = false,
    this.initialMuteEnable = true,
    this.cameraType = CameraType.front,
    required this.onCameraStateChange,
    required this.onMicroStateChange,
    this.width = 150,
    this.height = 250,
    this.avatar,
  }) : super(key: key);

  @override
  State<MeetingCamera> createState() => _MeetingCameraState();
}

class _MeetingCameraState extends State<MeetingCamera> {
  late bool isCameraOn = widget.initialCameraEnable;
  late bool isMuted = widget.initialMuteEnable;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: StackLayout(
        layoutGravity: Alignment.center,
        children: [
          if (isCameraOn)
            ImageView(
              image: widget.avatar,
              scaleType: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          // CameraView(
          //   type: widget.cameraType,
          // ),
          else
            ImageView(
              image: widget.avatar,
              scaleType: BoxFit.cover,
              width: widget.width * 0.5,
              shape: ViewShape.circular,
            ),
          LinearLayout(
            padding: 12,
            mainGravity: MainAxisAlignment.spaceBetween,
            positionType: ViewPositionType.flexBottom,
            orientation: Axis.horizontal,
            children: [
              IconView(
                icon: isCameraOn ? Icons.videocam : Icons.videocam_off_outlined,
                background: Colors.white24,
                tint: Colors.white,
                padding: 8,
                borderRadius: 24,
                onClick: (context) {
                  isCameraOn = !isCameraOn;
                  widget.onCameraStateChange.call(isCameraOn);
                  setState(() {});
                },
              ),
              IconView(
                icon: isMuted ? Icons.mic_off : Icons.mic,
                background: Colors.white24,
                tint: Colors.white,
                padding: 8,
                borderRadius: 24,
                onClick: (context) {
                  isMuted = !isMuted;
                  widget.onMicroStateChange.call(isMuted);
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
