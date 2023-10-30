import 'package:flutter/material.dart';
import 'package:flutter_androssy/services.dart';
import 'package:flutter_androssy/widgets.dart';

typedef OnControlClickListener = Function(bool);

class ARTCMeetingControls extends StatefulWidget {
  final Color? activeColor, activeIconColor;
  final Color? inactiveColor, inactiveIconColor;
  final ARTCButtonProperty cancelProperty;

  final bool isCameraOn;
  final bool isFrontCamera;
  final bool isMicrophoneEnabled;
  final bool isScreenShared;
  final bool isRiseHand;
  final bool isSilent;

  final OnControlClickListener? onCameraOn;
  final OnControlClickListener? onMicrophone;
  final OnControlClickListener? onRiseHand;
  final OnControlClickListener? onScreenShare;
  final OnControlClickListener? onSilent;
  final OnControlClickListener? onSwitchCamera;
  final OnViewClickListener? onCancel;
  final OnViewClickListener? onMore;

  const ARTCMeetingControls({
    Key? key,
    this.activeColor,
    this.activeIconColor,
    this.inactiveColor,
    this.inactiveIconColor,
    this.isCameraOn = false,
    this.isFrontCamera = true,
    this.isMicrophoneEnabled = false,
    this.isRiseHand = false,
    this.isScreenShared = false,
    this.isSilent = false,
    this.onCameraOn,
    this.onMore,
    this.onMicrophone,
    this.onRiseHand,
    this.onScreenShare,
    this.onSilent,
    this.onSwitchCamera,
    this.onCancel,
    this.cancelProperty = const ARTCButtonProperty(),
  }) : super(key: key);

  @override
  State<ARTCMeetingControls> createState() => _ARTCMeetingControlsState();
}

class _ARTCMeetingControlsState extends State<ARTCMeetingControls> {
  late bool isCameraOn = widget.isCameraOn;
  late bool isFrontCamera = widget.isFrontCamera;
  late bool isMicrophoneEnabled = widget.isMicrophoneEnabled;
  late bool isRiseHand = widget.isRiseHand;
  late bool isSilent = widget.isSilent;
  late bool isScreenShared = widget.isScreenShared;

  @override
  void didUpdateWidget(covariant ARTCMeetingControls oldWidget) {
    isCameraOn = widget.isCameraOn;
    isFrontCamera = widget.isFrontCamera;
    isMicrophoneEnabled = widget.isMicrophoneEnabled;
    isRiseHand = widget.isRiseHand;
    isSilent = widget.isSilent;
    isScreenShared = widget.isScreenShared;
    super.didUpdateWidget(oldWidget);
  }

  void onCameraOn() => widget.onCameraOn?.call(isCameraOn);

  void onMicrophoneEnable() => widget.onMicrophone?.call(isMicrophoneEnabled);

  void onRiseHand() => widget.onRiseHand?.call(isRiseHand);

  void onScreenShare() => widget.onScreenShare?.call(isScreenShared);

  void onSilent() => widget.onSilent?.call(isSilent);

  void onSwitchCamera() => widget.onSwitchCamera?.call(isFrontCamera);

  @override
  Widget build(BuildContext context) {
    var primary = Theme.of(context).primaryColor;

    var activeBG = widget.activeColor ?? primary;
    var inactiveBG = widget.inactiveColor ?? primary.withAlpha(15);

    var activeIC = widget.activeIconColor ?? Colors.white;
    var inactiveIC = widget.inactiveIconColor ?? primary;

    return LinearLayout(
      width: double.infinity,
      orientation: Axis.horizontal,
      mainGravity: MainAxisAlignment.spaceBetween,
      crossGravity: CrossAxisAlignment.center,
      paddingHorizontal: 24,
      paddingVertical: 12,
      children: [
        IconView(
          padding: 8,
          size: 40,
          borderRadius: 24,
          icon: isMicrophoneEnabled ? Icons.mic : Icons.mic_off,
          tint: isMicrophoneEnabled ? activeIC : inactiveIC,
          background: isMicrophoneEnabled ? activeBG : inactiveBG,
          onClick: (context) {
            isMicrophoneEnabled = !isMicrophoneEnabled;
            setState(onMicrophoneEnable);
          },
        ),
        IconView(
          padding: 8,
          size: 40,
          borderRadius: 24,
          icon: isCameraOn
              ? Icons.videocam_outlined
              : Icons.videocam_off_outlined,
          tint: isCameraOn ? activeIC : inactiveIC,
          background: isCameraOn ? activeBG : inactiveBG,
          onClick: (context) {
            isCameraOn = !isCameraOn;
            setState(onCameraOn);
          },
        ),
        IconView(
          borderRadius: 24,
          icon: widget.cancelProperty.icon,
          padding: widget.cancelProperty.padding,
          size: widget.cancelProperty.size,
          tint: widget.cancelProperty.tint,
          background: widget.cancelProperty.background,
          onClick: widget.onCancel,
          rippleColor: widget.cancelProperty.splashColor ?? Colors.transparent,
          pressedColor: widget.cancelProperty.splashColor ?? Colors.transparent,
        ),
        IconView(
          borderRadius: 24,
          padding: 8,
          size: 40,
          icon: isScreenShared
              ? Icons.screen_share_outlined
              : Icons.stop_screen_share_outlined,
          tint: isScreenShared ? activeIC : inactiveIC,
          background: isScreenShared ? activeBG : inactiveBG,
          onClick: (context) {
            isScreenShared = !isScreenShared;
            setState(onScreenShare);
          },
        ),
        // IconView(
        //   padding: 8,
        //   visibility: ViewVisibility.gone,
        //   icon: Icons.back_hand_outlined,
        //   tint: isRiseHand ? activeIC : inactiveIC,
        //   background: isRiseHand ? activeBG : inactiveBG,
        //   onClick: (context) {
        //     isRiseHand = !isRiseHand;
        //     setState(onRiseHand);
        //   },
        // ),
        IconView(
          borderRadius: 24,
          padding: 8,
          size: 40,
          icon: Icons.more_vert,
          tint: inactiveIC,
          background: inactiveBG,
          onClick: widget.onMore,
        ),
      ],
    );
  }
}

class ARTCButtonProperty {
  final dynamic icon;
  final double padding;
  final double size;
  final Color tint;
  final Color background;
  final Color? splashColor;

  const ARTCButtonProperty({
    this.background = Colors.red,
    this.icon = Icons.call_end,
    this.padding = 8,
    this.size = 24,
    this.splashColor,
    this.tint = Colors.white,
  });
}
