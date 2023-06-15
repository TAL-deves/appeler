import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';

typedef OnControlClickListener = Function(bool);

class MeetingControls extends StatefulWidget {
  final Color? activeColor, activeIconColor;
  final Color? inactiveColor, inactiveIconColor;
  final ButtonProperty cancelProperty;

  final bool isCameraOn;
  final bool isFrontCamera;
  final bool isMuted;
  final bool isScreenShared;
  final bool isRiseHand;
  final bool isSilent;

  final OnControlClickListener? onCameraOn;
  final OnControlClickListener? onMute;
  final OnControlClickListener? onRiseHand;
  final OnControlClickListener? onScreenShare;
  final OnControlClickListener? onSilent;
  final OnControlClickListener? onSwitchCamera;
  final OnViewClickListener? onCancel;
  final OnViewClickListener? onMore;

  const MeetingControls({
    Key? key,
    this.activeColor,
    this.activeIconColor,
    this.inactiveColor,
    this.inactiveIconColor,
    this.isCameraOn = false,
    this.isFrontCamera = true,
    this.isMuted = false,
    this.isRiseHand = false,
    this.isScreenShared = false,
    this.isSilent = false,
    this.onCameraOn,
    this.onMore,
    this.onMute,
    this.onRiseHand,
    this.onScreenShare,
    this.onSilent,
    this.onSwitchCamera,
    this.onCancel,
    this.cancelProperty = const ButtonProperty(),
  }) : super(key: key);

  @override
  State<MeetingControls> createState() => _MeetingControlsState();
}

class _MeetingControlsState extends State<MeetingControls> {
  late bool isCameraOn = widget.isCameraOn;
  late bool isFrontCamera = widget.isFrontCamera;
  late bool isMuted = widget.isMuted;
  late bool isRiseHand = widget.isRiseHand;
  late bool isSilent = widget.isSilent;
  late bool isScreenShared = widget.isScreenShared;

  @override
  void didUpdateWidget(covariant MeetingControls oldWidget) {
    isCameraOn = widget.isCameraOn;
    isFrontCamera = widget.isFrontCamera;
    isMuted = widget.isMuted;
    isRiseHand = widget.isRiseHand;
    isSilent = widget.isSilent;
    isScreenShared = widget.isScreenShared;
    super.didUpdateWidget(oldWidget);
  }

  void onCameraOn() => widget.onCameraOn?.call(isCameraOn);

  void onMute() => widget.onMute?.call(isMuted);

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
      orientation: Axis.horizontal,
      mainGravity: MainAxisAlignment.spaceBetween,
      paddingHorizontal: 24,
      paddingVertical: 12,
      children: [
        IconView(
          padding: 8,
          icon: isMuted ? Icons.mic_off : Icons.mic,
          tint: isMuted ? activeIC : inactiveIC,
          background: isMuted ? activeBG : inactiveBG,
          onClick: (context) {
            isMuted = !isMuted;
            setState(onMute);
          },
        ),
        IconView(
          padding: 8,
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
          icon: widget.cancelProperty.icon,
          padding: widget.cancelProperty.padding,
          size: widget.cancelProperty.size,
          tint: widget.cancelProperty.tint,
          background: widget.cancelProperty.background,
          onClick: widget.onCancel,
          rippleColor: widget.cancelProperty.splashColor,
          pressedColor: widget.cancelProperty.splashColor,
        ),
        IconView(
          padding: 8,
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
          padding: 8,
          visibility: ViewVisibility.visible,
          icon: Icons.more_vert,
          tint: inactiveIC,
          background: inactiveBG,
          onClick: widget.onMore,
        ),
      ],
    );
  }
}

class ButtonProperty {
  final dynamic icon;
  final double padding;
  final double size;
  final Color tint;
  final Color background;
  final Color? splashColor;

  const ButtonProperty({
    this.background = Colors.red,
    this.icon = Icons.call_end,
    this.padding = 8,
    this.size = 24,
    this.splashColor,
    this.tint = Colors.white,
  });
}
